#!/bin/bash

# Check if input file exist, download it if absent
if [ ! -f "data/huri.csv" ]; then
    echo "data/huri.csv does not exist, downloading."
    mkdir -p data
    cd data
    # http://www.interactome-atlas.org/data/
    wget -N http://www.interactome-atlas.org/data/HuRI.tsv

    # Add header
    sed -i '1s/^/geneA\tgeneB\n/' HuRI.tsv

    # Convert TSV to CSV for RML mapper
    sed -e 's/"/\\"/g' -e 's/\t/","/g' -e 's/^/"/' -e 's/$/"/'  -e 's/\r//' HuRI.tsv > huri.csv

    cd ..
fi

echo "Converting YARRRML mappings to RML"
yarrrml-parser -i mapping.yarrr.yml -o data/mapping.rml.ttl

echo "Running RML mapper, output to data/ folder"
rm data/bio2kg-huri.ttl
java -jar /opt/rmlmapper.jar -m data/mapping.rml.ttl -o data/bio2kg-huri.ttl -s turtle -f ../functions_ids.ttl 
