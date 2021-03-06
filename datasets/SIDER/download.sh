#!/bin/bash

# Check if input file exist, download it if absent
if [ ! -f "data/meddra_all_label_se.csv" ]; then
    echo "data/meddra_all_label_se.csv does not exist, downloading..."
    mkdir -p data && cd data

    # http://sideeffects.embl.de/download/
    # Docs: http://sideeffects.embl.de/media/download/README
    # Warning: Given stitch compound ID does not resolve with identifers.org/stitch
    wget -N http://sideeffects.embl.de/media/download/meddra_all_label_se.tsv.gz
    wget -N ftp://xi.embl.de/SIDER/latest/meddra_all_indications.tsv.gz
    wget -N ftp://xi.embl.de/SIDER/latest/meddra_all_se.tsv.gz
    wget -N ftp://xi.embl.de/SIDER/latest/meddra_freq.tsv.gz

    gzip -d *.gz

    # Convert TSV to CSV for RML Mapper
    sed -e 's/"//g' -e 's/\t/","/g' -e 's/^/"/' -e 's/$/"/' -e 's/\r//' meddra_all_label_se.tsv > meddra_all_label_se.csv

    # TODO: add header based on http://sideeffects.embl.de/media/download/README
    # sed -i '1s/^/UniProtKB accession,UniProtKB ID,EntrezGene,RefSeq,NCBI GI number,PDB,Pfam,GO,PIRSF,IPI,UniRef100,UniRef90,UniRef50,UniParc,PIR-PSD accession,NCBI taxonomy,MIM,UniGene,Ensembl,PubMed ID,EMBL GenBank DDBJ,EMBL protein_id\n/' iproclass.csv

    # The next lines are used to produce a sample for development, comment them to process the complete files
    # mv meddra_all_label_se.csv meddra_all_label_se-full.csv
    # head -n 1000 meddra_all_label_se-full.csv > meddra_all_label_se.csv
fi
