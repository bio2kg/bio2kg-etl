#!/bin/bash

tar -xzvf *.tar.gz

# Convert commas to | for ddbs column and PubMed publications CURIEs to URIs
sed -e 's/,/|/g' -e 's/pubmed:/https:\/\/identifiers.org\/pubmed:/g' preppi_final600.txt > preppi.tsv

# Convert TSV to CSV for RML Mapper
sed -e 's/"//g' -e 's/\t/","/g' -e 's/^/"/' -e 's/$/"/' -e 's/\r//' preppi.tsv > preppi.csv
