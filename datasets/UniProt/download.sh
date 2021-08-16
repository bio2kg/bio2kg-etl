#!/bin/bash

# Check if input file exist, download it if absent
if [ ! -f "data/uniprot.csv" ]; then
    echo "data/uniprot.csv does not exist, downloading."
    mkdir -p data
    cd data
    wget -N ftp://ftp.ebi.ac.uk/pub/databases/genenames/uniprot/tsv/uniprot_complete_set.txt
    # Convert TSV to CSV for RML Mapper
    sed -e 's/"//g' -e 's/\t/","/g' -e 's/^/"/' -e 's/$/"/' -e 's/\r//' uniprot_complete_set.txt > uniprot.csv
    cd ..
fi

# mv data/uniprot.csv data/uniprot-full.csv
# head -n 1000 data/uniprot-full.csv > data/uniprot.csv