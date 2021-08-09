#!/bin/bash

# Check if input file exist, download it if absent
if [ ! -f "data/mim2gene_medgen" ]; then
    echo "data/mim2gene_medgen does not exist, downloading."
    mkdir -p data && cd data
    # https://ftp.ncbi.nlm.nih.gov/gene/DATA/
    wget -N https://ftp.ncbi.nlm.nih.gov/gene/DATA/mim2gene_medgen
    echo "Download gene_info.gz (600MB), can take some time..."
    wget -N https://ftp.ncbi.nlm.nih.gov/gene/DATA/gene_info.gz
    gzip -d *.gz

    # Convert TSV to CSV for RML Mapper
    sed -e 's/"//g' -e 's/\t/","/g' -e 's/^/"/' -e 's/$/"/' -e 's/\r//' mim2gene_medgen > mim2gene_medgen.csv

    # The next lines are used to produce a sample for development, comment them to process the complete files
    # mv gene_info.csv gene_info-full.csv
    # head -n 1000 gene_info-full.csv > gene_info.csv

    cd ..
fi

PROCESS_FILE="${1:=ncbigene-mim2gene.yarrr.yml}"
# ncbigene-geneinfo.yarrr.yml

echo "Converting YARRRML mappings to RML"
yarrrml-parser -i $PROCESS_FILE -o data/mapping.rml.ttl

echo "Running RML mapper, output to data/ folder"
rm data/bio2kg-$PROCESS_FILE.ttl
java -jar /opt/rmlmapper.jar -m data/mapping.rml.ttl -o data/bio2kg-$PROCESS_FILE.ttl -s turtle -f ../functions_ids.ttl 

# head -n 40 data/bio2kg-ctd.ttl
