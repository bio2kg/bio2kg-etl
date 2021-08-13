#!/bin/bash

# Check if input file exist, download it if absent
if [ ! -f "data/hgnc.csv" ]; then
    echo "data/hgnc.csv does not exist, downloading."
    mkdir -p data
    cd data
    wget -N ftp://ftp.ebi.ac.uk/pub/databases/genenames/hgnc/tsv/hgnc_complete_set.txt
    # Convert TSV to CSV for RML Mapper
    sed -e 's/"//g' -e 's/\t/","/g' -e 's/^/"/' -e 's/$/"/' -e 's/\r//' hgnc_complete_set.txt > hgnc.csv
    cd ..
fi

# mv data/hgnc.csv data/hgnc-full.csv
# head -n 1000 data/hgnc-full.csv > data/hgnc.csv