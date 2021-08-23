#!/bin/bash

# http://stitch.embl.de/cgi/download.pl
# wget -N http://stitch.embl.de/download/chemical_chemical.links.detailed.v5.0.tsv.gz
# wget -N http://stitch.embl.de/download/protein_chemical.links.detailed.v5.0.tsv.gz

gzip -d *.gz
# Convert TSV to CSV for RML Mapper
sed -e 's/"//g' -e 's/\t/","/g' -e 's/^/"/' -e 's/$/"/' -e 's/\r//' chemical_chemical.links.detailed.v5.0.tsv > chemical_chemical.links.detailed.csv
# sed -e 's/"//g' -e 's/\t/","/g' -e 's/^/"/' -e 's/$/"/' -e 's/\r//' protein_chemical.links.detailed.v5.0.tsv > protein_chemical.links.detailed.csv
