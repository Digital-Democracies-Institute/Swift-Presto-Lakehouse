#!/bin/bash


change_flag=0
container_name=4cat_backend
container_directory=data
destination_directory=~/4catdata3
destination_directory_results="$destination_directory"/search-results
docker_directory=usr/src/app
s3_bucket_4cat="s3://ddi-techteam-obj-storage/4cat-v138/data/"
extensions=("csv" "ndjson")

for ext in "${extensions[@]}"; do
    
    if [ ! -d "$destination_directory_results"/"$ext" ]; then
	mkdir -p "$destination_directory_results"/"$ext"
	echo "Directory created: ""$destination_directory_results"/"$ext"
    fi

    if [ ! -d "$destination_directory_results/$ext""/tmp" ]; then
	mkdir -p "$destination_directory_results/$ext""/tmp"
	echo "Directory created: ""$destination_directory_results/$ext""/tmp"	
    fi

    while IFS= read -r file_path; do
	filename=$(basename "$file_path")
	destfilepath="$destination_directory_results/$ext/$filename"
	destfilepath_tmp="$destination_directory_results/$ext/""tmp/""$filename"

	# Extract last modified time for source file
	src_mtime=$(docker exec "$container_name" bash -c "stat -c %Y $container_directory/$file_path")
    
	# Check if the file exists or if the source file has been modified
	if [[ ! -f "$destfilepath" || $src_mtime -gt $(stat -c %Y "$destfilepath") ]]; then

	    # Copy the file to the destination temporary directory
	    docker cp "$container_name":"$docker_directory/$container_directory/$file_path" "$destfilepath_tmp"

	    # remove carriage returns
	    awk 'NR%2-1{gsub(/\r?\n|\r/, FS)} NR>1{printf RS}1' RS=\" ORS= $destfilepath_tmp > "$destfilepath"

	    # remove 1st line
	    sed -i '1d' "$destfilepath"

	    # remove tmp file
	    rm $destfilepath_tmp
	    
	    # set the change flag
	    change_flag=1
	fi

    done < <(docker exec "$container_name" bash -c "cd $container_directory && find . -type f  -name \"*.""$ext""\"")    
done

# Synchronize with S3 server
if [ $change_flag -eq 1 ]; then
    s3cmd sync --delete-removed "$destination_directory/" "$s3_bucket_4cat"    
fi
