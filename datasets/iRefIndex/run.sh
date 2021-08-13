#!/bin/bash

echo "Converting YARRRML mappings to RML"
yarrrml-parser -i mapping-irefindex.yarrr.yml -o data/mapping.rml.ttl

# rm data/bio2kg-irefindex.ttl
echo "Running RML mapper, output to data/ folder"
java -jar /opt/rmlmapper.jar -m data/mapping.rml.ttl -o data/bio2kg-irefindex.ttl -s turtle -f ../functions_ids.ttl 
