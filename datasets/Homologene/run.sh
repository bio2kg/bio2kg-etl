#!/bin/bash

# Check if input file exist, download it if absent
if [ ! -f "data/iproclass.csv" ]; then
    echo "data/iproclass.csv does not exist, downloading (11G)"
    mkdir -p data && cd data
    # https://ftp.ncbi.nlm.nih.gov/pub/HomoloGene/README
    # wget -N https://ftp.ncbi.nlm.nih.gov/pub/HomoloGene/current/homologene.data
    # wget -N https://ftp.ncbi.nlm.nih.gov/pub/HomoloGene/current/homologene.xml.gz
    gzip -d *.gz

    # Convert TSV to CSV for RML Mapper
    sed -e 's/"//g' -e 's/\t/","/g' -e 's/^/"/' -e 's/$/"/' -e 's/\r//' homologene.data > homologene.csv

    # Add columns labels based on https://ftp.ncbi.nlm.nih.gov/pub/HomoloGene/README
    sed -i '1s/^/HomoloGene group id,Taxonomy ID,Gene ID,Gene Symbol,Protein gi,Protein accession\n/' homologene.csv


    # The next lines are used to produce a sample for development, comment them to process the complete files
    # mv iproclass.csv iproclass-full.csv
    # head -n 1000 iproclass-full.csv > iproclass.csv

    cd ..
fi

PROCESS_FILE="${1:-homologene-mapping.yarrr.yml}"

echo "Converting YARRRML mappings to RML"
yarrrml-parser -i $PROCESS_FILE -o data/mapping.rml.ttl

echo "Running RML mapper, output to data/ folder"
rm data/bio2kg-$PROCESS_FILE.ttl
java -jar /opt/rmlmapper.jar -m data/mapping.rml.ttl -o data/bio2kg-$PROCESS_FILE.ttl -s turtle -f ../functions_ids.ttl 

# head -n 40 data/bio2kg-ctd.ttl
