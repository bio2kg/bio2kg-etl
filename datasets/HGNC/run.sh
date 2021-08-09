#!/bin/bash

# Check if input file exist, download it if absent
if [ ! -f "data/hgnc.csv" ]; then
    echo "data/hgnc.csv does not exist, downloading."
    mkdir -p data
    cd data
    wget -N ftp://ftp.ebi.ac.uk/pub/databases/genenames/hgnc/tsv/hgnc_complete_set.txt
    # Convert TSV to CSV for RML Mapper
    sed -e 's/"//g' -e 's/\t/","/g' -e 's/^/"/' -e 's/$/"/' -e 's/\r//' hgnc_complete_set.txt > hgnc.csv
    cd ..
fi

echo "Converting YARRRML mappings to RML"
yarrrml-parser -i hgnc-mapping.yarrr.yml -o data/mapping.rml.ttl
# yarrrml-parser -i TMhgnc.yml -o data/TMhgnc.rml.ttl

echo "Running RML mapper, output to data/ folder"
rm data/bio2kg-hgnc.ttl
java -jar /opt/rmlmapper.jar -m data/mapping.rml.ttl -o data/bio2kg-hgnc.ttl -s turtle -f ../functions_ids.ttl 

echo "RDF output:"
head -n 40 data/bio2kg-hgnc.ttl


##Example to run quick python scripts:
# pip install pandas
# python3 <<HEREDOC
# import pandas as pd
# csv_table=pd.read_table('hgnc_complete_set.tsv',sep='\t')
# csv_table.applymap
# s = pd.Series(csv_table)
# s.str.strip()
# csv_table.to_csv('hgnc_complete_set.csv',index=False)
# HEREDOC
