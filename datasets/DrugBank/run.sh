#!/bin/bash

DRUGBANK_VERSION="${DRUGBANK_VERSION:=5-1-8}"

if [ ! -f "data/full database.xml" ]; then
    echo "data/full database.xml does not exist, downloading version $DRUGBANK_VERSION"
    mkdir -p data
    cd data
    curl -Lfs -o drugbank.zip -u $DRUGBANK_USERNAME:$DRUGBANK_PASSWORD https://go.drugbank.com/releases/$DRUGBANK_VERSION/downloads/all-full-database
    unzip drugbank.zip
    # mv full\ database.xml drugbank.xml
    cd ..
fi

echo "Convert YARRRML to RML mappings"
yarrrml-parser -i drugbank-mapping.yarrr.yml -o data/mapping.rml.ttl

echo "Running RML mapper, output to data/ folder"
java $1 -jar /opt/rmlmapper.jar -m data/mapping.rml.ttl -o data/bio2kg-drugbank.ttl -s turtle

# java $1 -jar /opt/rmlmapper.jar -m data/mapping.rml.ttl -o data/bio2kg-drugbank.ttl -s turtle -f ../functions_ids.ttl 

