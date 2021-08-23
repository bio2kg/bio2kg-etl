#!/bin/bash


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
