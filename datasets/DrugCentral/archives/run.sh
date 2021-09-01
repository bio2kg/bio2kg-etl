#!/bin/bash

# PROCESS_FILE="${1:-mapping-drugcentral-sql.yarrr.yml}"

ls *.yarrr.yml | while read PROCESS_FILE 
do
    PROCESS_FILE=$(echo $PROCESS_FILE | sed "s/\.yarrr\.yml//g")
    echo "Converting $PROCESS_FILE YARRRML mappings to RML"
    yarrrml-parser -i $PROCESS_FILE.yarrr.yml -o data/$PROCESS_FILE.rml.ttl

    # echo "Running RML mapper, output to data/ folder"
    # rm data/bio2kg-$PROCESS_FILE.ttl 
    java -jar /opt/rmlmapper.jar -m data/$PROCESS_FILE.rml.ttl -o data/bio2kg-$PROCESS_FILE.ttl -s turtle -f ../functions_ids.ttl 
done
