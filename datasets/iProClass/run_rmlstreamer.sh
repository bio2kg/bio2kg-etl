#!/bin/bash

# oc login --username your.username --server=https://api.dsri2.unimaas.nl:6443

# oc project bio2kg

export DATASET=iProClass
DATASET_PATH=/mnt/datasets/$DATASET
export FLINK_POD=$(oc get pod --selector app=flink --selector component=jobmanager --no-headers -o=custom-columns=NAME:.metadata.name)

# echo "Run script to download dataset on DSRI"
# oc cp download.sh $FLINK_POD:$DATASET_PATH/
# oc exec $FLINK_POD -- bash -c "cd $DATASET_PATH/ && ./download.sh"

# oc exec $FLINK_POD -- wget -O /mnt/RMLStreamer.jar https://github.com/RMLio/RMLStreamer/releases/download/v2.1.1/RMLStreamer-2.1.1.jar
# oc exec $FLINK_POD -- wget -O /mnt/RMLStreamer-2.1.0.jar https://github.com/RMLio/RMLStreamer/releases/download/v2.1.0/RMLStreamer-2.1.0.jar
# oc exec $FLINK_POD -- mkdir -p /mnt/$DATASET
# oc exec $FLINK_POD -- cd /mnt && wget -q -N ftp://ftp.proteininformationresource.org/databases/iproclass/iproclass.tb.gz
# oc exec $FLINK_POD -- gzip -d *.gz
# oc exec $FLINK_POD -- sed -e 's/"//g' -e 's/\t/","/g' -e 's/^/"/' -e 's/$/"/' -e 's/\r//' iproclass.tb > iproclass.csv
# oc exec $FLINK_POD -- sed -i '1s/^/UniProtKB accession,UniProtKB ID,EntrezGene,RefSeq,NCBI GI number,PDB,Pfam,GO,PIRSF,IPI,UniRef100,UniRef90,UniRef50,UniParc,PIR-PSD accession,NCBI taxonomy,MIM,UniGene,Ensembl,PubMed ID,EMBL GenBank DDBJ,EMBL protein_id\n/' iproclass.csv


# oc cp ../IdsRmlFunctions.jar $FLINK_POD:/opt/flink/lib/
# oc cp ../functions_ids.ttl $FLINK_POD:/opt/flink
# oc cp ../ids_java_mapping.ttl $FLINK_POD:/opt/flink

# oc cp ../functions_ids.ttl $FLINK_POD:$DATASET_PATH
# oc cp ../ids_java_mapping.ttl $FLINK_POD:$DATASET_PATH

# oc cp ../functions_ids.ttl $FLINK_POD:/mnt
# oc cp ../ids_java_mapping.ttl $FLINK_POD:/mnt

echo "Converting YARRRML mappings to RML"
yarrrml-parser -i iproclass-mapping.yarrr.yml -o data/mapping.rml.ttl

echo "Update and copy the $DATASET mappings to the RML Streamer on DSRI"
sed -ir 's/data\/iproclass.csv/\/mnt\/datasets\/iProClass\/data\/iproclass.csv/g' data/mapping.rml.ttl
oc cp data/mapping.rml.ttl $FLINK_POD:$DATASET_PATH/data/

# oc exec $FLINK_POD -- ls -alh /mnt/$DATASET

# oc exec $FLINK_POD -- sed -ir 's/data\/iproclass.csv/\/mnt\/iProClass\/data\/iproclass.csv/g' /mnt/$DATASET/data/mapping.rml.ttl

PARALLELISM=64
echo "Running the RML Streamer on $PARALLELISM threads"

## Modified RMLStreamer with IDS functions:
oc exec $FLINK_POD -- /opt/flink/bin/flink run -p $PARALLELISM -c io.rml.framework.Main /mnt/RMLStreamer.jar toFile -m $DATASET_PATH/data/mapping.rml.ttl -o $DATASET_PATH/output/bio2kg-$DATASET.nt --job-name "RMLStreamer Bio2KG - $DATASET"

## Original RMLStreamer:
# oc exec $FLINK_POD -- /opt/flink/bin/flink run -p $PARALLELISM -c io.rml.framework.Main /mnt/RMLStreamer-2.1.0.jar toFile -m $DATASET_PATH/mapping.rml.ttl -o /mnt/bio2kg-$DATASET.nt --job-name "RMLStreamer Bio2KG - $DATASET"

## Change directory first:
# oc exec $FLINK_POD -- bash -c "cd /mnt && /opt/flink/bin/flink run -p $PARALLELISM -c io.rml.framework.Main RMLStreamer.jar toFile -m mapping.rml.ttl -o /mnt/bio2kg-$DATASET.nt --job-name \"RMLStreamer Bio2KG - $DATASET\""

## Run directly from flink pod
# /opt/flink/bin/flink run -p 64 -c io.rml.framework.Main /mnt/RMLStreamer.jar toFile -m mapping.rml.ttl -o /mnt/bio2kg-rmlstreamer.nt --job-name "RMLStreamer Bio2KG - iProClass"


# echo "Copy the $DATASET RDF output from the DSRI to the local machine"
# oc cp $FLINK_POD:/mnt/bio2kg-$DATASET.ttl data/