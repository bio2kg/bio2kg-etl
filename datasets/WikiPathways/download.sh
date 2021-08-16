#!/bin/bash

# Check if input file exist, download it if absent
if [ ! -f "data/wikipathways.csv" ]; then
    echo "data/wikipathways.csv does not exist, downloading."
    mkdir -p data
    cd data
    wget -N ftp://ftp.ebi.ac.uk/pub/databases/genenames/wikipathways/tsv/wikipathways_complete_set.txt
    # Convert TSV to CSV for RML Mapper
    sed -e 's/"//g' -e 's/\t/","/g' -e 's/^/"/' -e 's/$/"/' -e 's/\r//' wikipathways_complete_set.txt > wikipathways.csv
    cd ..
fi

# mv data/wikipathways.csv data/wikipathways-full.csv
# head -n 1000 data/wikipathways-full.csv > data/wikipathways.csv