#!/bin/bash


echo "Converting YARRRML mappings to RML"
yarrrml-parser -i wikipathways-mapping.yarrr.yml -o data/mapping.rml.ttl
# yarrrml-parser -i TMwikipathways.yml -o data/TMwikipathways.rml.ttl

echo "Running RML mapper, output to data/ folder"
rm data/bio2kg-wikipathways.ttl
java -jar /opt/rmlmapper.jar -m data/mapping.rml.ttl -o data/bio2kg-wikipathways.ttl -s turtle -f ../functions_ids.ttl 

echo "RDF output:"
head -n 40 data/bio2kg-wikipathways.ttl


##Example to run quick python scripts:
# pip install pandas
# python3 <<HEREDOC
# import pandas as pd
# csv_table=pd.read_table('wikipathways_complete_set.tsv',sep='\t')
# csv_table.applymap
# s = pd.Series(csv_table)
# s.str.strip()
# csv_table.to_csv('wikipathways_complete_set.csv',index=False)
# HEREDOC
