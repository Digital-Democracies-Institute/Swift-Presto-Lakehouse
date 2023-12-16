#!/bin/bash

change_flag=0
source_directory="/var/lib/docker/volumes/4cat-v133_4cat_data/_data"
destination_directory="/home/lofelix/4catdata2"
destination_directory_countposts="$destination_directory"/count-posts
destination_directory_results_csv="$destination_directory"/search-results/csv
destination_directory_results_ndjson="$destination_directory"/search-results/ndjson

today=$(date +%Y-%m-%d)

# Iterate over all count-posts files in the source directory
for filepath in "$source_directory"/*.csv; do
    filename=$(basename "$filepath")

    # Check if the file exists
    if [[ "$filename" =~ ^count-posts ]]; then 
        # Copy the file to the destination directory

	if [ ! -f "$destination_directory_countposts"/"$filename" ]; then
            echo Copying "$filename" to "$destination_directory_countposts"
            cp "$filepath" "$destination_directory_countposts"
	    sed -i '1d' "$destination_directory_countposts"/"$filename"
	    change_flag=1
	fi
    else
	if [ ! -f "$destination_directory_results_csv"/"$filename" ]; then
            echo Copying "$filename" to "$destination_directory_results_csv" and remove carriage returns within quotes
	    awk 'NR%2-1{gsub(/\r?\n/, FS)} NR>1{printf RS}1' RS=\" ORS= $filepath > "$destination_directory_results_csv"/"$filename"

	    sed -i '1d' "$destination_directory_results_csv"/"$filename"
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


if [ $change_flag -eq 1 ]; then
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    "$script_dir/sync_4cat_s3.sh"
fi
