#!/bin/bash

# PROCESS_FILE="${1:-iproclass-mapping.yarrr.yml}"

echo "Converting YARRRML mappings to RML"
yarrrml-parser -i iproclass-mapping.yarrr.yml -o data/mapping.rml.ttl

# echo "Running RML mapper, output to data/ folder"
# rm data/bio2kg-iproclass.ttl
# java $1 -jar /opt/rmlmapper.jar -m data/mapping.rml.ttl -o data/bio2kg-iproclass.ttl -s turtle -f ../functions_ids.ttl 
java -jar /opt/rmlmapper.jar -m data/mapping.rml.ttl -o data/bio2kg-iproclass.ttl

# echo "Running RocketRML"
# node ../rocketrml.js -m iproclass-mapping.yarrr.yml
