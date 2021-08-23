#!/bin/bash

gzip -d *.gz
# Convert TSV to CSV for RML Mapper
sed -e 's/"//g' -e 's/\t/","/g' -e 's/^/"/' -e 's/$/"/' -e 's/\r//' drug.target.interaction.tsv > drug.target.interaction.csv
sed -e 's/"//g' -e 's/\t/","/g' -e 's/^/"/' -e 's/$/"/' -e 's/\r//' structures.smiles.tsv > structures.smiles.csv
