#!/bin/bash

echo "Converting YARRRML mappings to RML"
yarrrml-parser -i huri-mapping.yarrr.yml -o data/mapping.rml.ttl

echo "Running RML mapper, output to data/ folder"
rm data/bio2kg-huri.ttl
java -jar /opt/rmlmapper.jar -m data/mapping.rml.ttl -o data/bio2kg-huri.ttl -s turtle -f ../functions_ids.ttl 
