#!/bin/bash

# Check if input file exist, download it if absent
if [ ! -f "data/pharmgkb.csv" ]; then
    echo "data/pharmgkb.csv does not exist, downloading."
    mkdir -p data
    cd data
    # https://www.pharmgkb.org/downloads
    # wget -N https://api.pharmgkb.org/v1/download/file/data/relationships.zip
    # wget -N https://api.pharmgkb.org/v1/download/file/data/genes.zip
    # wget -N https://api.pharmgkb.org/v1/download/file/data/drugs.zip
    # wget -N https://api.pharmgkb.org/v1/download/file/data/chemicals.zip
    # wget -N https://api.pharmgkb.org/v1/download/file/data/phenotypes.zip

    # wget -N https://api.pharmgkb.org/v1/download/file/data/pathways-biopax.zip
    # wget -N https://api.pharmgkb.org/v1/download/file/data/pathways-tsv.zip
    # wget -N 
    # wget -N 
    # wget -N 
    # wget -N 

    unzip -o "*.zip"
    # Convert TSV to CSV for RML Mapper
    # sed -e 's/"//g' -e 's/\t/","/g' -e 's/^/"/' -e 's/$/"/' -e 's/\r//' relationships.tsv > relationships.csv
    # find . -name "*.tsv" -exec gzip -d  sed -e 's/"//g' -e 's/\t/","/g' -e 's/^/"/' -e 's/$/"/' -e 's/\r//' {}.tsv > {}.csv

    find . -name "*.tsv"  | while read file 
    do
        csv_file=$(echo $file | sed "s/\.tsv$/.csv/g")
        sed -e 's/"//g' -e 's/\t/","/g' -e 's/^/"/' -e 's/$/"/' -e 's/\r//' $file > "$csv_file"
    done
fi
