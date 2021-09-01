#!/bin/bash

# Check if input file exist, download it if absent
if [ ! -f "data/drugcentral.csv" ]; then
    echo "data/drugcentral.csv does not exist, downloading."
    # https://drugcentral.org/download
    mkdir -p data
    cd data
    wget -N https://unmtid-shinyapps.net/download/drug.target.interaction.tsv.gz
    wget -N https://unmtid-shinyapps.net/download/structures.smiles.tsv
    gzip -d *.gz
    # Convert TSV to CSV for RML Mapper
    sed -e 's/"//g' -e 's/\t/","/g' -e 's/^/"/' -e 's/$/"/' -e 's/\r//' drug.target.interaction.tsv > drug.target.interaction.csv
    sed -e 's/"//g' -e 's/\t/","/g' -e 's/^/"/' -e 's/$/"/' -e 's/\r//' structures.smiles.tsv > structures.smiles.csv
    cd ..
fi

# mv data/drugcentral.csv data/drugcentral-full.csv
# head -n 1000 data/drugcentral-full.csv > data/drugcentral.csv