#!/bin/bash

echo "Converting YARRRML mappings to RML"
yarrrml-parser -i string-mapping.yarrr.yml -o data/mapping.rml.ttl

# echo "Running RML mapper, output to data/ folder"
# rm data/bio2kg-string.ttl
# java -jar /opt/rmlmapper.jar -m data/mapping.rml.ttl -o data/bio2kg-string.ttl -s turtle -f ../functions_ids.ttl 

# echo "RDF output:"
# head -n 40 data/bio2kg-string.ttl

