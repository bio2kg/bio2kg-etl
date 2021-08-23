#!/bin/bash

# Convert TSV to CSV for RML Mapper
sed -e 's/"//g' -e 's/\t/","/g' -e 's/^/"/' -e 's/$/"/' -e 's/\r//' homologene.data > homologene.csv

# Add columns labels based on https://ftp.ncbi.nlm.nih.gov/pub/HomoloGene/README
sed -i '1s/^/HomoloGene group id,Taxonomy ID,Gene ID,Gene Symbol,Protein gi,Protein accession\n/' homologene.csv
