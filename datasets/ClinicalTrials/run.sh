#!/bin/bash

# Check if input file exist, download it if absent
if [ ! -f "data/AllPublicXML.zip" ]; then
    echo "data/AllPublicXML.zip does not exist, downloading."
    mkdir -p data
    cd data
    wget -N  https://clinicaltrials.gov/AllPublicXML.zip
    unzip AllPublicXML.zip
    cd ..
fi

# echo "Converting YARRRML mappings to RML"
# yarrrml-parser -i clinicaltrials-mapping.yarrr.yml -o data/mapping.rml.ttl
# # yarrrml-parser -i TMclinicaltrials.yml -o data/TMclinicaltrials.rml.ttl

# echo "Running RML mapper, output to data/ folder"
# rm data/bio2kg-clinicaltrials.ttl
# java -jar /opt/rmlmapper.jar -m data/mapping.rml.ttl -o data/bio2kg-clinicaltrials.ttl -s turtle -f ../functions_ids.ttl 
