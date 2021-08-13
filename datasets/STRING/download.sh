#!/bin/bash

# Check if input file exist, download it if absent
if [ ! -f "data/string.csv" ]; then
    echo "data/string.csv does not exist, downloading."
    mkdir -p data
    cd data
    # https://string-db.org/cgi/download
    wget -N https://stringdb-static.org/download/protein.links.full.v11.0/9606.protein.links.full.v11.0.txt.gz
    wget -N https://stringdb-static.org/download/protein.physical.links.full.v11.0/9606.protein.physical.links.full.v11.0.txt.gz

    gzip -d *.gz
    # Convert TSV to CSV for RML Mapper
    sed -e 's/"//g' -e 's/\t/","/g' -e 's/^/"/' -e 's/$/"/' -e 's/\r//' 9606.protein.links.full.v11.0.txt > proteins.csv
    sed -e 's/"//g' -e 's/\t/","/g' -e 's/^/"/' -e 's/$/"/' -e 's/\r//' 9606.protein.physical.links.full.v11.0.txt > proteins-physical.csv
    cd ..
fi
