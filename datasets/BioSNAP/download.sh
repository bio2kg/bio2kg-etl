#!/bin/bash

# Check if input file exist, download it if absent
if [ ! -f "data/disease-chemical.csv" ]; then
    echo "data/disease-chemical.csv does not exist, downloading."
    mkdir -p data && cd data
    # http://snap.stanford.edu/biodata/index.html
    # http://snap.stanford.edu/mambo/
    # Code of their miners: https://github.com/snap-stanford/miner-data
    wget -N https://snap.stanford.edu/biodata/datasets/10004/files/DCh-Miner_miner-disease-chemical.tsv.gz
    gzip -d *.gz
    # Convert TSV to CSV for RML Mapper
    sed -e 's/"//g' -e 's/\t/","/g' -e 's/^/"/' -e 's/$/"/' -e 's/\r//' DCh-Miner_miner-disease-chemical.tsv > disease-chemical.csv
fi

## The next lines are used to produce a sample for development, comment them to process the complete files
# mv disease-chemical.csv disease-chemical-full.csv
# head -n 1000 disease-chemical-full.csv > disease-chemical.csv