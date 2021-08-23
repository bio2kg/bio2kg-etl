#!/bin/bash

# Check if input file exist, download it if absent
if [ ! -f "data/genage_human.csv" ]; then
    echo "data/genage_human.csv does not exist, downloading"
    mkdir -p data && cd data
    # https://genomics.senescence.info/download.html
    wget -N http://genomics.senescence.info/genes/human_genes.zip
    wget -N http://genomics.senescence.info/genes/models_genes.zip
    unzip -o "*.zip"
fi
