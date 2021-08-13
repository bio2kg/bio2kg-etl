#!/bin/bash

echo "Converting YARRRML mappings to RML"
yarrrml-parser -i mapping-clinicaltrials.yarrr.yml -o data/mapping.rml.ttl

mkdir -p data/mappings/
mkdir -p data/output/
count=0

find data/all-public-xml/* -name "*.xml" | while read XML_FILE 
do
    PROCESS_FILE=$(basename $XML_FILE)
    XML_FILE=$(echo $XML_FILE | sed "s/\//\\\\\//g")
    # PROCESS_FILE=$(basename $XML_FILE | sed "s/data\///g" | sed "s/data\///g")
    sed "s/CLINICALTRIALS_FILEPATH/$XML_FILE/g" data/mapping.rml.ttl > data/mappings/$PROCESS_FILE.rml.ttl

    echo "Running RML mapper for $PROCESS_FILE ($XML_FILE), output in data/output"
    java -jar /opt/rmlmapper.jar -m data/mappings/$PROCESS_FILE.rml.ttl -o data/output/bio2kg-$PROCESS_FILE.nt -s ntriples -f ../functions_ids.ttl 

    # echo "Running RocketRML"
    # node ../rocketrml.js "data/$PROCESS_FILE.rml.ttl" "data/bio2kg-$PROCESS_FILE.ttl"

    # Limit the amount of file processed for testing (to comment)
    ((count++))
    if [[ $count -eq 10 ]]; then
        break
    fi
done

echo "Merging all ntriples files"
cat data/output/*.nt > data/bio2kg-clinicaltrials.nt