#!/bin/bash


echo "Converting YARRRML mappings to RML"
yarrrml-parser -i mapping-uniprot.yarrr.yml -o data/mapping.rml.ttl
# yarrrml-parser -i TMuniprot.yml -o data/TMuniprot.rml.ttl

echo "Running RML mapper, output to data/ folder"
rm data/bio2kg-uniprot.ttl
java -jar /opt/rmlmapper.jar -m data/mapping.rml.ttl -o data/bio2kg-uniprot.ttl -s turtle -f ../functions_ids.ttl 

echo "RDF output:"
head -n 40 data/bio2kg-uniprot.ttl


##Example to run quick python scripts:
# pip install pandas
# python3 <<HEREDOC
# import pandas as pd
# csv_table=pd.read_table('uniprot_complete_set.tsv',sep='\t')
# csv_table.applymap
# s = pd.Series(csv_table)
# s.str.strip()
# csv_table.to_csv('uniprot_complete_set.csv',index=False)
# HEREDOC
