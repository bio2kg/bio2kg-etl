#!/bin/bash

# Check if input file exist, download it if absent
if [ ! -f "data/homologene.csv" ]; then
    echo "data/homologene.csv does not exist, downloading (11G)"
    mkdir -p data && cd data
    # https://ftp.ncbi.nlm.nih.gov/pub/HomoloGene/README
    wget -N https://ftp.ncbi.nlm.nih.gov/pub/HomoloGene/current/homologene.data
    # wget -N https://ftp.ncbi.nlm.nih.gov/pub/HomoloGene/current/homologene.xml.gz
    gzip -d *.gz

    # Convert TSV to CSV for RML Mapper
    sed -e 's/"//g' -e 's/\t/","/g' -e 's/^/"/' -e 's/$/"/' -e 's/\r//' homologene.data > homologene.csv

    # Add columns labels based on https://ftp.ncbi.nlm.nih.gov/pub/HomoloGene/README
    sed -i '1s/^/HomoloGene group id,Taxonomy ID,Gene ID,Gene Symbol,Protein gi,Protein accession\n/' homologene.csv
fi

## The next lines are used to produce a sample for development, comment them to process the complete files
# mv homologene.csv homologene-full.csv
# head -n 1000 homologene-full.csv > homologene.csv