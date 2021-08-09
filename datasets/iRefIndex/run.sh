#!/bin/bash

# Check if input file exist, download it if absent
if [ ! -f "data/irefindex.csv" ]; then
    echo "data/irefindex.csv does not exist, downloading."
    mkdir -p data
    cd data
    # http://www.interactome-atlas.org/data/
    wget -N https://irefindex.vib.be/download/irefindex/data/archive/release_17.0/psi_mitab/MITAB2.6/All.mitab.27062020.txt.zip

    # Add header
    # sed -i '1s/^/geneA\tgeneB\n/' HuRI.tsv

    # Convert TSV to CSV for RML mapper
    sed -e 's/"/\\"/g' -e 's/\t/","/g' -e 's/^/"/' -e 's/$/"/'  -e 's/\r//' All.mitab.27062020.txt > irefindex.csv

    cd ..
fi

# echo "Converting YARRRML mappings to RML"
# yarrrml-parser -i irefindex-mapping.yarrr.yml -o data/mapping.rml.ttl

# echo "Running RML mapper, output to data/ folder"
# rm data/bio2kg-irefindex.ttl
# java -jar /opt/rmlmapper.jar -m data/mapping.rml.ttl -o data/bio2kg-irefindex.ttl -s turtle -f ../functions_ids.ttl 
