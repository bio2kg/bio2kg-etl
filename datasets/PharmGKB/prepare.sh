#!/bin/bash

unzip -o "*.zip"

# Convert TSV to CSV for RML Mapper
find . -name "*.tsv"  | while read file 
do
    csv_file=$(echo $file | sed "s/\.tsv$/.csv/g")
    sed -e 's/"//g' -e 's/\t/","/g' -e 's/^/"/' -e 's/$/"/' -e 's/\r//' $file > "$csv_file"
done
