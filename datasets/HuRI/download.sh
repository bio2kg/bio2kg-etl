#!/bin/bash

# Check if input file exist, download it if absent
if [ ! -f "data/huri.csv" ]; then
    echo "data/huri.csv does not exist, downloading."
    mkdir -p data
    cd data
    # http://www.interactome-atlas.org/download
    wget -N http://www.interactome-atlas.org/data/HuRI.tsv

    # Add header
    sed -i '1s/^/geneA\tgeneB\n/' HuRI.tsv

    # Convert TSV to CSV for RML mapper
    sed -e 's/"/\\"/g' -e 's/\t/","/g' -e 's/^/"/' -e 's/$/"/'  -e 's/\r//' HuRI.tsv > huri.csv

    cd ..
fi
