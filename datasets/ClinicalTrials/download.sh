#!/bin/bash

# Check if input file exist, download it if absent
if [ ! -f "data/AllPublicXML.zip" ]; then
    echo "data/AllPublicXML.zip does not exist, downloading."
    mkdir -p data/all-public-xml
    cd data
    wget -N  https://unmtid-shinyapps.net/download/drug.target.interaction.tsv.gz
    unzip AllPublicXML.zip -d all-public-xml
fi
