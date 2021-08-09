#!/bin/bash

# Check if input file exist, download it if absent
if [ ! -f "data/genage_human.csv" ]; then
    echo "data/genage_human.csv does not exist, downloading (11G)"
    mkdir -p data && cd data
    # https://genomics.senescence.info/download.html
    wget -N http://genomics.senescence.info/genes/human_genes.zip
    wget -N http://genomics.senescence.info/genes/models_genes.zip
    unzip -o "*.zip"

    cd ..
fi

# PROCESS_FILE="${1:-mapping.yarrr.yml}"

# echo "Converting YARRRML mappings to RML"
# yarrrml-parser -i $PROCESS_FILE -o data/mapping.rml.ttl

# echo "Running RML mapper, output to data/ folder"
# rm data/bio2kg-$PROCESS_FILE.ttl
# java -jar /opt/rmlmapper.jar -m data/mapping.rml.ttl -o data/bio2kg-genage.ttl -s turtle -f ../functions_ids.ttl 

# head -n 40 data/bio2kg-genage.ttl
