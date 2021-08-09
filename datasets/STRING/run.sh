#!/bin/bash

# Check if input file exist, download it if absent
if [ ! -f "data/string.csv" ]; then
    echo "data/string.csv does not exist, downloading."
    mkdir -p data
    cd data
    # https://string-db.org/cgi/download
    wget -N https://stringdb-static.org/download/protein.links.full.v11.0/9606.protein.links.full.v11.0.txt.gz
    wget -N https://stringdb-static.org/download/protein.physical.links.full.v11.0/9606.protein.physical.links.full.v11.0.txt.gz

    gzip -d *.gz
    # Convert TSV to CSV for RML Mapper
    sed -e 's/"//g' -e 's/\t/","/g' -e 's/^/"/' -e 's/$/"/' -e 's/\r//' 9606.protein.links.full.v11.0.txt > proteins.csv
    sed -e 's/"//g' -e 's/\t/","/g' -e 's/^/"/' -e 's/$/"/' -e 's/\r//' 9606.protein.physical.links.full.v11.0.txt > proteins-physical.csv
    cd ..
fi

# echo "Converting YARRRML mappings to RML"
# yarrrml-parser -i string-mapping.yarrr.yml -o data/mapping.rml.ttl
# # yarrrml-parser -i TMstring.yml -o data/TMstring.rml.ttl

# echo "Running RML mapper, output to data/ folder"
# rm data/bio2kg-string.ttl
# java -jar /opt/rmlmapper.jar -m data/mapping.rml.ttl -o data/bio2kg-string.ttl -s turtle -f ../functions_ids.ttl 

# echo "RDF output:"
# head -n 40 data/bio2kg-string.ttl

