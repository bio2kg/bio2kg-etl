#!/bin/bash

# More datasets: http://snap.stanford.edu/biodata/index.html
# Even more datasets: http://snap.stanford.edu/mambo/
# Code of their miner: https://github.com/snap-stanford/miner-data

gzip -d *.gz

# Convert TSV to CSV for RML Mapper
sed -e 's/"//g' -e 's/\t/","/g' -e 's/^/"/' -e 's/$/"/' -e 's/\r//' DCh-Miner_miner-disease-chemical.tsv > input/DCh-Miner_miner-disease-chemical.csv
