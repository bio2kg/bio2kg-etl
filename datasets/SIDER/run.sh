#!/bin/bash

# Check if input file exist, download it if absent
if [ ! -f "data/meddra_all_label_se.csv" ]; then
    echo "data/meddra_all_label_se.csv does not exist, downloading..."
    mkdir -p data && cd data
    # http://sideeffects.embl.de/download/
    # TODO: find the columns docs
    wget -N http://sideeffects.embl.de/media/download/meddra_all_label_se.tsv.gz
    gzip -d *.gz

    # Convert TSV to CSV for RML Mapper
    sed -e 's/"//g' -e 's/\t/","/g' -e 's/^/"/' -e 's/$/"/' -e 's/\r//' meddra_all_label_se.tsv > meddra_all_label_se.csv

    # The next lines are used to produce a sample for development, comment them to process the complete files
    # mv meddra_all_label_se.csv meddra_all_label_se-full.csv
    # head -n 1000 meddra_all_label_se-full.csv > meddra_all_label_se.csv

    cd ..
fi

# PROCESS_FILE="${1:=sider-mapping.yarrr.yml}"

# echo "Converting YARRRML mappings to RML"
# yarrrml-parser -i $PROCESS_FILE -o data/mapping.rml.ttl

# echo "Running RML mapper, output to data/ folder"
# rm data/bio2kg-$PROCESS_FILE.ttl
# java -jar /opt/rmlmapper.jar -m data/mapping.rml.ttl -o data/bio2kg-$PROCESS_FILE.ttl -s turtle -f ../functions_ids.ttl 

# head -n 40 data/bio2kg-ctd.ttl
