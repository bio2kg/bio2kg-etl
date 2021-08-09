#!/bin/bash

# Check if input file exist, download it if absent
if [ ! -f "data/disease-chemical.csv" ]; then
    echo "data/disease-chemical.csv does not exist, downloading."
    mkdir -p data && cd data
    # http://ctdbase.org/downloads/
    wget -N https://snap.stanford.edu/biodata/datasets/10004/files/DCh-Miner_miner-disease-chemical.tsv.gz
    gzip -d *.gz
    # Convert TSV to CSV for RML Mapper
    sed -e 's/"//g' -e 's/\t/","/g' -e 's/^/"/' -e 's/$/"/' -e 's/\r//' DCh-Miner_miner-disease-chemical.tsv > disease-chemical.csv

    # The next lines are used to produce a sample for development, comment them to process the complete files
    # mv CTD_chem_gene_ixns.csv CTD_chem_gene_ixns-full.csv
    # mv CTD_chemicals_diseases.csv CTD_chemicals_diseases-full.csv
    # head -n 1000 CTD_chem_gene_ixns-full.csv > CTD_chem_gene_ixns.csv
    # head -n 1000 CTD_chemicals_diseases-full.csv > CTD_chemicals_diseases.csv

    cd ..
fi

PROCESS_FILE="${1:-snap-biodata-mapping.yarrr.yml}"

echo "Converting YARRRML mappings to RML"
yarrrml-parser -i $PROCESS_FILE -o data/mapping.rml.ttl

echo "Running RML mapper, output to data/ folder"
rm data/bio2kg-snap-biodata.ttl
java -jar /opt/rmlmapper.jar -m data/mapping.rml.ttl -o data/bio2kg-snap-biodata.ttl -s turtle -f ../functions_ids.ttl 

# head -n 40 data/bio2kg-ctd.ttl
