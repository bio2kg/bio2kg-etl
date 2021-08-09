#!/bin/bash

# Check if input file exist, download it if absent
if [ ! -f "data/CTD_chem_gene_ixns.csv" ]; then
    echo "data/CTD_chem_gene_ixns.csv does not exist, downloading."
    mkdir -p data && cd data
    # http://ctdbase.org/downloads/
    wget -N http://ctdbase.org/reports/CTD_chemicals_diseases.csv.gz
    wget -N http://ctdbase.org/reports/CTD_chem_gene_ixns.csv.gz

    wget -N http://ctdbase.org/reports/CTD_chem_go_enriched.csv.gz
    wget -N http://ctdbase.org/reports/CTD_chem_pathways_enriched.csv.gz
    wget -N http://ctdbase.org/reports/CTD_genes_diseases.csv.gz # 2G
    wget -N http://ctdbase.org/reports/CTD_genes_pathways.csv.gz
    wget -N http://ctdbase.org/reports/CTD_diseases_pathways.csv.gz
    wget -N http://ctdbase.org/reports/CTD_pheno_term_ixns.csv.gz
    wget -N http://ctdbase.org/reports/CTD_exposure_studies.csv.gz
    # wget -N http://ctdbase.org/reports/CTD_exposure_events.csv.gz
    wget -N http://ctdbase.org/reports/CTD_Phenotype-Disease_biological_process_associations.csv.gz

    gzip -d *.gz
    # Delete useless lines at the start of the file to keep only columns labels
    tail -n +28 CTD_chem_gene_ixns.csv > CTD_chem_gene_ixns-processed.csv
    tail -n +28 CTD_chemicals_diseases.csv > CTD_chemicals_diseases-processed.csv
    sed -i '2d' CTD_chem_gene_ixns-processed.csv
    sed -i '2d' CTD_chemicals_diseases-processed.csv

    # The next lines are used to produce a sample for development, comment them to process the complete files
    # mv CTD_chem_gene_ixns.csv CTD_chem_gene_ixns-full.csv
    # mv CTD_chemicals_diseases.csv CTD_chemicals_diseases-full.csv
    # head -n 1000 CTD_chem_gene_ixns-full.csv > CTD_chem_gene_ixns.csv
    # head -n 1000 CTD_chemicals_diseases-full.csv > CTD_chemicals_diseases.csv

    cd ..
fi

PROCESS_FILE="${1:-ctd-chemical-gene.yarrr.yml}"

# pip install rdfizer
# rdfizer -c rdfizer.ini

echo "Converting YARRRML mappings to RML"
yarrrml-parser -i $PROCESS_FILE -o data/mapping.rml.ttl

echo "Running RML mapper, output to data/ folder"
rm data/bio2kg-$PROCESS_FILE.ttl
java -jar /opt/rmlmapper.jar -m data/mapping.rml.ttl -o data/bio2kg-$PROCESS_FILE.ttl -s turtle -f ../functions_ids.ttl 

# head -n 40 data/bio2kg-ctd.ttl
