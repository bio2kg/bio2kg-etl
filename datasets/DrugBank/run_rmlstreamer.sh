#!/bin/bash

# oc login --username your.username --server=https://api.dsri2.unimaas.nl:6443
# oc project bio2kg

export DATASET=DrugBank
export DATASET_PATH=/mnt/$DATASET
export FLINK_POD=$(oc get pod --selector app=flink --selector component=jobmanager --no-headers -o=custom-columns=NAME:.metadata.name)

# echo "Run script to download dataset on DSRI"
# oc cp download.sh $FLINK_POD:$DATASET_PATH/
# oc exec $FLINK_POD -- bash -c "cd $DATASET_PATH/ && ./download.sh $DRUGBANK_USERNAME $DRUGBANK_PASSWORD"

# Or copy the sample drugbank file to the DSRI
# oc cp data/drugbank.xml $FLINK_POD:$DATASET_PATH/drugbank.xml

echo "Converting YARRRML mappings to RML"
yarrrml-parser -i drugbank-mapping.yarrr.yml -o data/mapping.rml.ttl

echo "Copy the $DATASET mappings to the RML Streamer on DSRI"
sed -ir 's/data\/drugbank.xml/\/mnt\/DrugBank\/drugbank.xml/g' data/mapping.rml.ttl
oc cp data/mapping.rml.ttl $FLINK_POD:$DATASET_PATH/

PARALLELISM=1
echo "Running the RML Streamer on $PARALLELISM threads"
oc exec $FLINK_POD -- /opt/flink/bin/flink run -p $PARALLELISM -c io.rml.framework.Main /mnt/RMLStreamer.jar toFile -m $DATASET_PATH/mapping.rml.ttl -o /mnt/bio2kg-$DATASET.nt --job-name "RMLStreamer Bio2KG - $DATASET"

# oc exec $FLINK_POD -- /opt/flink/bin/flink run --detached -p $PARALLELISM -c io.rml.framework.Main /mnt/RMLStreamer.jar toFile -m $DATASET_PATH/mapping.rml.ttl -o /mnt/bio2kg-$DATASET.nt --job-name "RMLStreamer Bio2KG - $DATASET"


# echo "Copy the $DATASET RDF output from the DSRI to the local machine"
# oc cp $FLINK_POD:/mnt/bio2kg-$DATASET.ttl data/


# echo "Downloading DrugBank on DSRI for the RMLStreamer directly"
# oc exec $FLINK_POD -- wget -O /mnt/RMLStreamer.jar https://github.com/RMLio/RMLStreamer/releases/download/v2.1.1/RMLStreamer-2.1.1.jar
# oc exec $FLINK_POD -- mkdir -p /mnt/$DATASET
# oc exec $FLINK_POD -- curl -Lfs -o /mnt/$DATASET/drugbank.zip -u $DRUGBANK_USERNAME:$DRUGBANK_PASSWORD https://go.drugbank.com/releases/$DRUGBANK_VERSION/downloads/all-full-database
# oc exec $FLINK_POD -- unzip -o /mnt/$DATASET/drugbank.zip -d /mnt/$DATASET
# oc exec $FLINK_POD -- sed -i -r 's/<drugbank-id primary="true">(.*)<\/drugbank-id>/<drugbank-id-primary>\1<\/drugbank-id-primary>/g' /mnt/$DATASET/full\ database.xml
