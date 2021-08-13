#!/bin/bash

# Check if input file exist, download it if absent
if [ ! -f "data/irefindex.csv" ]; then
    echo "data/irefindex.csv does not exist, downloading."
    mkdir -p data
    cd data
    # http://www.interactome-atlas.org/data/
    wget -N https://irefindex.vib.be/download/irefindex/data/archive/release_17.0/psi_mitab/MITAB2.6/All.mitab.27062020.txt.zip
    # unzip "*.zip"
    zcat *.zip > irefindex.txt

    # Convert TSV to CSV for RML mapper
    # sed -e 's/"/\\"/g' -e 's/\t/","/g' -e 's/^/"/' -e 's/$/"/'  -e 's/\r//' irefindex.txt > irefindex.csv
    sed -e 's/"//g' -e 's/\t/","/g' -e 's/^/"/' -e 's/$/"/'  -e 's/\r//' irefindex.txt > irefindex.csv

    # sed -i 's/genbank indentifier:/GenBank:/g' irefindex.csv
    cd ..
fi

# mv data/irefindex.csv data/irefindex-full.csv
# head -n 1000 data/irefindex-full.csv > data/irefindex.csv