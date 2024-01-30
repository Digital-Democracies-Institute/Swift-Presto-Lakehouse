#!/bin/bash


change_flag=0
source_directory="/var/lib/docker/volumes/4cat-v133_4cat_data/_data"
destination_directory="/home/lofelix/4catdata2"
destination_directory_countposts="$destination_directory"/count-posts
destination_directory_results_csv="$destination_directory"/search-results/csv
destination_directory_results_ndjson="$destination_directory"/search-results/ndjson

# Iterate over all count-posts files in the source directory
for filepath in "$source_directory"/*.csv; do
    filename=$(basename "$filepath")
    src_mtime=$(stat -c %Y "$filepath")

    # If files start with "count-posts", just copy it to the countposts directory
    if [[ "$filename" =~ ^count-posts ]]; then 

	destfilepath=$destination_directory_countposts"/"$filename
	dest_mtime=$(stat -c %Y "$destfilepath")
    
	# Check if the file exists or if the source file has been modified
	if [[ ! -f "$destfilepath" || $src_mtime -gt $dest_mtime ]]; then

	    # Copy the file to the destination directory
            echo Copying "$filename" to "$destination_directory_countposts"
            cp "$filepath" "$destination_directory_countposts"

	    # delete the first line (the headers) of the file
	    sed -i '1d' "$destfilepath"

	    # set change flag
	    change_flag=1
	fi
    else

	destfilepath=$destination_directory_results_csv"/"$filename
	dest_mtime=$(stat -c %Y "$destfilepath")
	
	if [[ ! -f "$destfilepath" || $src_mtime -gt $dest_mtime ]]; then

	    # Remove carriage returns within quotes and writes the results to the search-results directory
            echo Copying "$filename" to "$destination_directory_results_csv" and remove carriage returns within quotes
	    awk 'NR%2-1{gsub(/\r?\n/, FS)} NR>1{printf RS}1' RS=\" ORS= $filepath > "$destfilepath"

	    # delete the first line (the headers) of the file
	    sed -i '1d' "$destfilepath"
	    change_flag=1
	fi
    fi

done


# Iterate over all ndjson files in the source directory
for filepath in "$source_directory"/*.ndjson; do
    filename=$(basename "$filepath")

    if [ ! -f "$destination_directory_results_ndjson"/"$filename" ]; then
        # Copy the file to the destination directory
        echo Copying "$filename" to "$destination_directory_results_ndjson"
        cp "$filepath" "$destination_directory_results_ndjson"
	change_flag=1
    fi
done


# delete files in the destinatino directory that don't exist in source directory
for subdir in "$destination_directory"/*/; do
    for filepath in "$subdir"/*; do
    	filename=$(basename "$filepath")
    	if [ ! -f "$source_directory"/"$filename" ]; then
           rm filepath
	   change_flag=1
    	   fi
    done
done

if [ $change_flag -eq 1 ]; then
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    "$script_dir/sync_4cat_s3.sh"
fi
