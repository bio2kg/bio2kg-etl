#!/bin/bash

mkdir -p data
cd data

## Download files
wget -N https://ftp.ebi.ac.uk/pub/databases/interpro/interpro.xml.gz
wget -N https://ftp.ebi.ac.uk/pub/databases/interpro/interpro.dtd

gzip -d *.gz

