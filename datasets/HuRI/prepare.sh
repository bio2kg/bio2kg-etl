#!/bin/bash

# Add header
sed -i '1s/^/geneA\tgeneB\n/' HuRI.tsv

# Convert TSV to CSV for RML mapper
sed -e 's/"/\\"/g' -e 's/\t/","/g' -e 's/^/"/' -e 's/$/"/'  -e 's/\r//' HuRI.tsv > HuRI.csv
