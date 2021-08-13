#!/bin/bash

# Check if input file exist, download it if absent
if [ ! -f "data/gendr_manipulations.csv" ]; then
    echo "data/gendr_manipulations.csv does not exist, downloading"
    mkdir -p data && cd data
    # https://genomics.senescence.info/download.html
    wget -N https://genomics.senescence.info/diet/dataset.zip
    unzip -o "*.zip"
    sed -i 's/,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,//g' gendr_manipulations.csv
fi