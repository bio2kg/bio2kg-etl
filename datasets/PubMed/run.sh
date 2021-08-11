#!/bin/bash

echo "Converting YARRRML mappings to RML"
yarrrml-parser -i pubmed-mapping.yarrr.yml -o data/mapping.rml.ttl

# rm data/bio2kg-*.ttl

ls data/pubmed21n*.xml | while read PROCESS_FILE 
do
    PROCESS_FILE=$(echo $PROCESS_FILE | sed "s/data\///g")
    sed "s/PUBMED_FILEPATH/$PROCESS_FILE/g" data/mapping.rml.ttl > data/$PROCESS_FILE.rml.ttl

    # echo "Running RML mapper for $PROCESS_FILE"
    # java -jar /opt/rmlmapper.jar -m data/$PROCESS_FILE.rml.ttl -o data/bio2kg-$PROCESS_FILE.ttl -s turtle -f ../functions_ids.ttl 

    echo "Running RocketRML"
    node ../rocketrml.js "data/$PROCESS_FILE.rml.ttl"
done
