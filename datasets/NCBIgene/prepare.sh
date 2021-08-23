#!/bin/bash

gzip -d *.gz

# Convert TSV to CSV for RML Mapper
sed -e 's/"//g' -e 's/\t/","/g' -e 's/^/"/' -e 's/$/"/' -e 's/\r//' mim2gene_medgen > mim2gene_medgen.csv
sed -e 's/"//g' -e 's/\t/","/g' -e 's/^/"/' -e 's/$/"/' -e 's/\r//' gene_info > gene_info.csv
