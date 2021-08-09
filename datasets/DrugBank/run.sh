#!/bin/bash

DRUGBANK_VERSION="${DRUGBANK_VERSION:=5-1-8}"

if [ ! -f "data/drugbank.xml" ]; then
    echo "data/drugbank.xml does not exist, downloading version $DRUGBANK_VERSION"
    mkdir -p data
    cd data
    curl -Lfs -o drugbank.zip -u $DRUGBANK_USERNAME:$DRUGBANK_PASSWORD https://go.drugbank.com/releases/$DRUGBANK_VERSION/downloads/all-full-database
    unzip drugbank.zip
    # Replace <drugbank-id @primary=true> by <drugbank-id-primary> to enable RML to get the main DrugBank ID
    sed -r 's/<drugbank-id primary="true">(.*)<\/drugbank-id>/<drugbank-id-primary>\1<\/drugbank-id-primary>/g' full\ database.xml > drugbank.xml
    cd ..
fi

echo "Converting YARRRML mappings to RML"
yarrrml-parser -i drugbank-mapping.yarrr.yml -o data/mapping.rml.ttl

echo "Running RML mapper, output to data/ folder"
rm data/bio2kg-drugbank.ttl
java $1 -jar /opt/rmlmapper.jar -m data/mapping.rml.ttl -o data/bio2kg-drugbank.ttl -s turtle -f ../functions_ids.ttl 


