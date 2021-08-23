#!/bin/bash

# http://www.interactome-atlas.org/data/

# unzip "*.zip"
zcat *.zip > irefindex.txt

# Convert TSV to CSV for RML mapper
sed -e 's/"//g' -e 's/\t/","/g' -e 's/^/"/' -e 's/$/"/'  -e 's/\r//' irefindex.txt > irefindex.csv
# sed -e 's/"/\\"/g' -e 's/\t/","/g' -e 's/^/"/' -e 's/$/"/'  -e 's/\r//' irefindex.txt > irefindex.csv