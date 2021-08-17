#!/bin/bash
# oc login --username your.username --server=https://api.dsri2.unimaas.nl:6443
# oc project bio2kg

DATASET="${1:-HGNC}"
DBA_PASSWORD="${2:-password}"
dataset=$(echo "$DATASET" | tr '[:upper:]' '[:lower:]')
DATASET_PATH=/mnt/$DATASET
VIRTUOSO=$(oc get pod --selector app=triplestore --no-headers -o=custom-columns=NAME:.metadata.name)
GRAPH=https://triplestore-bio2kg.apps.dsri2.unimaas.nl/DAV/ldp/$dataset

# Delete RDF file to LDP DAV
oc exec $VIRTUOSO -- isql -U dba -P $DBA_PASSWORD exec="DAV_DELETE ('/DAV/ldp/$dataset', 0, 'dav', '$DBA_PASSWORD');"

# Delete RDF graph with SPARQL
curl -u dav:$DBA_PASSWORD https://triplestore-bio2kg.apps.dsri2.unimaas.nl/sparql?query=CLEAR GRAPH <$GRAPH>

# Load file to LDP DAV after deleting previous graph
curl -u dav:$DBA_PASSWORD --data-binary @data/bio2kg-hgnc.ttl -H "Accept: text/turtle" -H "Content-type: text/turtle" -H "Slug: $dataset" https://triplestore-bio2kg.apps.dsri2.unimaas.nl/DAV/ldp

# Generate metadata
d2s metadata analyze https://triplestore-bio2kg.apps.dsri2.unimaas.nl/sparql -o data/metadata.ttl -g $GRAPH
curl -u dav:$DBA_PASSWORD --data-binary @data/metadata.ttl -H "Accept: text/turtle" -H "Content-type: text/turtle" -H "Slug: $dataset-metadata" https://triplestore-bio2kg.apps.dsri2.unimaas.nl/DAV/ldp


curl -s -v --head https://ftp.ncbi.nlm.nih.gov/gene/DATA/mim2gene_medgen 2>&1 | grep '^< Last-Modified:'

curl -s -v --head https://ftp.ncbi.nlm.nih.gov/gene/DATA/mim2gene_medgen 2>&1 | grep '^< Last-Modified:'

# oc exec $VIRTUOSO -- wget -O /mnt/RMLStreamer.jar https://github.com/RMLio/RMLStreamer/releases/download/v2.1.1/RMLStreamer-2.1.1.jar

# echo "Run script to download dataset on DSRI"
# oc cp download.sh $FLINK_POD:/mnt/$DATASET/
# oc exec $VIRTUOSO -- bash -c "cd /mnt/$DATASET/ && ./download.sh"
