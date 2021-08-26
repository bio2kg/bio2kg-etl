#!/bin/bash

gzip -d *.gz

# Convert TSV to CSV for RML Mapper
sed -e 's/"/\"/g' -e 's/\t/","/g' -e 's/^/"/' -e 's/$/"/' -e 's/\r//' iproclass.tb > iproclass.csv

# Add columns labels based on ftp://ftp.proteininformationresource.org/databases/iproclass/iproclass.tb.readme
sed -i '1s/^/UniProtKB accession,UniProtKB ID,EntrezGene,RefSeq,NCBI GI number,PDB,Pfam,GO,PIRSF,IPI,UniRef100,UniRef90,UniRef50,UniParc,PIR-PSD accession,NCBI taxonomy,MIM,UniGene,Ensembl,PubMed ID,EMBL GenBank DDBJ,EMBL protein_id\n/' iproclass.csv
# echo "UniProtKB accession,UniProtKB ID,EntrezGene,RefSeq,NCBI GI number,PDB,Pfam,GO,PIRSF,IPI,UniRef100,UniRef90,UniRef50,UniParc,PIR-PSD accession,NCBI taxonomy,MIM,UniGene,Ensembl,PubMed ID,EMBL GenBank DDBJ,EMBL protein_id\n" > iproclass-processed.csv
# cat iproclass.csv >> iproclass-processed.csv

# The next lines are used to produce a sample for development, comment them to process the complete files
mv iproclass.csv iproclass-full.csv
head -n 1000 iproclass-full.csv > iproclass.csv

