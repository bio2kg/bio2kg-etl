#!/bin/bash

# 1. Retrieve informations about downloading the files in the metadata.ttl file
# 2. If connected to a triplestore: try to get the latest version for this dataset if exists
# 3. If latest version exist: compare the lastUpdated and lastModified date
# 4. Download and process the data only if newer available
# 5. Check if the generated RDF is fine (detect if ETL broken)
# 6. Delete previous file and graph with iSQL and SPARQL (clear graph)
# 7. Upload new file/graph via Virtuoso LDP DAV
# 8. Run d2s to generate metadata for this new graph,
#    Increment the version, and store it to the dataset metadata graph

echo "Converting YARRRML mappings to RML"
yarrrml-parser -i mapping-interpro.yarrr.yml -o data/mapping.rml.ttl

# Need to run in data otherwise RMLmapper fails due to missing DTD file
cp data/interpro.dtd ./

rm data/bio2kg-interpro.ttl
echo "Running RML mapper, output to data/ folder"
java $1 -jar /opt/rmlmapper.jar -m data/mapping.rml.ttl -o data/bio2kg-interpro.ttl -s turtle -f ../functions_ids.ttl 
# || { echo 'RML mapper failed' ; exit 1; }

rm interpro.dtd


# cd ../..
# yarn upgrade file:$HOME/sandbox/RocketRML
# cd datasets/InterPro

# echo "Running RocketRML"
# node ../rocketrml.js -m interpro-mapping.yarrr.yml
