#!/bin/bash

# Check if input file exist, download it if absent
if [ ! -f "data/pubmed21n0001.xml" ]; then
    echo "data/pubmed21n0001.xml does not exist, downloading."
    mkdir -p data
    cd data
    
    # Download only a file
    wget -N ftp://ftp.ncbi.nlm.nih.gov/pubmed/baseline/pubmed21n0001.xml.gz
    # wget -N -a download.log ftp://ftp.ncbi.nlm.nih.gov/pubmed/baseline/pubmed21n0972.xml.gz

    # Download only 10
    # wget -N -a download.log -r -A 'pubmed21n000*.xml.gz' -nH --cut-dirs=1 ftp://ftp.ncbi.nlm.nih.gov/pubmed/baseline/

    ## Download all baseline and update files
    # wget -N -a download.log -r -A xml.gz -nH --cut-dirs=1 ftp://ftp.ncbi.nlm.nih.gov/pubmed/baseline/
    # wget -N -a download.log -r -A xml.gz -nH --cut-dirs=1 ftp://ftp.ncbi.nlm.nih.gov/pubmed/updatefiles/

    ## Unzip all files in subdir with name of the zip file
    # find . -name "*.gz" -exec gzip -d  {} +

    gzip -d *.gz
    cd ..
fi

echo "Converting YARRRML mappings to RML"
yarrrml-parser -i pubmed-mapping.yarrr.yml -o data/mapping.rml.ttl

# rm data/bio2kg-*.ttl

ls data/pubmed21n*.xml | while read PROCESS_FILE 
do
    PROCESS_FILE=$(echo $PROCESS_FILE | sed "s/data\///g")

    echo "Preparing RML for $PROCESS_FILE"
    sed "s/PUBMED_FILEPATH/$PROCESS_FILE/g" data/mapping.rml.ttl > data/$PROCESS_FILE.rml.ttl

    echo "Running RML mapper, output to data/ folder"
    java -jar /opt/rmlmapper.jar -m data/$PROCESS_FILE.rml.ttl -o data/bio2kg-$PROCESS_FILE.ttl -s turtle -f ../functions_ids.ttl 
done
