#!/bin/bash

wget -N ftp://ftp.ebi.ac.uk/pub/databases/genenames/hgnc/tsv/hgnc_complete_set.txt

# Convert TSV to CSV for RML Mapper
sed -e 's/"//g' -e 's/\t/","/g' -e 's/^/"/' -e 's/$/"/' -e 's/\r//' hgnc_complete_set.txt > hgnc_complete_set.csv