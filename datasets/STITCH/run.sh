#!/bin/bash

echo "Converting YARRRML mappings to RML"
yarrrml-parser -i stitch-mapping.yarrr.yml -o data/mapping.rml.ttl

rm data/bio2kg-stitch.ttl
echo "Running RML mapper, output to data/ folder"
java $1 -jar /opt/rmlmapper.jar -m data/mapping.rml.ttl -o data/bio2kg-stitch.ttl -s turtle -f ../functions_ids.ttl 

