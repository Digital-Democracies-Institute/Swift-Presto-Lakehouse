#!/bin/bash

source_directory="/home/lofelix/4catdata2/"
s3_bucket_4cat="s3://ddi-techteam-obj-storage/4cat-v133/data/"

s3cmd sync --delete-removed "$source_directory" "$s3_bucket_4cat"
