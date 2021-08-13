#!/bin/bash

echo "Converting YARRRML mappings to RML"
yarrrml-parser -i drugbank-mapping.yarrr.yml -o data/mapping.rml.ttl

# echo "Running RML mapper, output to data/ folder"
# rm data/bio2kg-drugbank.ttl
# java $1 -jar /opt/rmlmapper.jar -m data/mapping.rml.ttl -o data/bio2kg-drugbank.ttl -s turtle -f ../functions_ids.ttl || { echo 'RML mapper failed' ; exit 1; }

cd ../..
yarn upgrade file:$HOME/sandbox/RocketRML
cd datasets/DrugBank

echo "Running RocketRML"
node ../rocketrml.js drugbank-mapping.yarrr.yml

# GitHub Action: Error: Xpath-iterator not installed, cannot run with xpathLib:"pugixml"

# echo "Run ShEx validation with shex.js"
# /opt/node_modules/shex/bin/validate \
#     -x ../bio2kg.shex \
#     -d data/bio2kg-drugbank.ttl \
#     -s https://w3id.org/bio2kg/shape/shex \
#     -n https://identifiers.org/drugbank:DB00001
#     # DB00001 is the node to validate