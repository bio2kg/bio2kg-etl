#!/bin/bash

# Check if input file exist, download it if absent
if [ ! -f "data/pubmed21n0001.xml" ]; then
    echo "data/pubmed21n0001.xml does not exist, downloading."
    mkdir -p data
    cd data
    
    # Download only a file
    # wget -N ftp://ftp.ncbi.nlm.nih.gov/pubmed/baseline/pubmed21n0001.xml.gz
    # wget -N ftp://ftp.ncbi.nlm.nih.gov/pubmed/baseline/pubmed21n0972.xml.gz

    # Download only 10
    wget -N -r -A 'pubmed21n000*.xml.gz' -nH --cut-dirs=1 ftp://ftp.ncbi.nlm.nih.gov/pubmed/baseline/

    ## Download all baseline and update files
    # wget -N -r -A xml.gz -nH --cut-dirs=1 ftp://ftp.ncbi.nlm.nih.gov/pubmed/baseline/
    # wget -N -r -A xml.gz -nH --cut-dirs=1 ftp://ftp.ncbi.nlm.nih.gov/pubmed/updatefiles/

    ## Unzip all files recursively in the right subdir
    find . -name "*.gz" -exec gzip -d  {} +

    # gzip -d *.gz
    cd ..
fi

