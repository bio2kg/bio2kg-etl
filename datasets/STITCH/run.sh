#!/bin/bash

# Check if input file exist, download it if absent
if [ ! -f "data/protein_chemical.csv" ]; then
    echo "data/protein_chemical.csv does not exist, downloading."
    mkdir -p data
    cd data
    # http://stitch.embl.de/cgi/download.pl
    # wget -N http://stitch.embl.de/download/chemical_chemical.links.detailed.v5.0.tsv.gz
    wget -N http://stitch.embl.de/download/protein_chemical.links.detailed.v5.0.tsv.gz

    gzip -d *.gz
    # Convert TSV to CSV for RML Mapper
    sed -e 's/"//g' -e 's/\t/","/g' -e 's/^/"/' -e 's/$/"/' -e 's/\r//' chemical_chemical.links.detailed.v5.0.tsv > chemical_chemical.csv
    # sed -e 's/"//g' -e 's/\t/","/g' -e 's/^/"/' -e 's/$/"/' -e 's/\r//' protein_chemical.links.detailed.v5.0.tsv > protein_chemical.csv
    cd ..
fi

echo "Converting YARRRML mappings to RML"
yarrrml-parser -i stitch-mapping.yarrr.yml -o data/mapping.rml.ttl
# yarrrml-parser -i TMstitch.yml -o data/TMstitch.rml.ttl

echo "Running RML mapper, output to data/ folder"
rm data/bio2kg-stitch.ttl
java -jar /opt/rmlmapper.jar -m data/mapping.rml.ttl -o data/bio2kg-stitch.ttl -s turtle -f ../functions_ids.ttl 

