
# prot1	prot2	str_score	protpep_score	str_max_score	red_score	ort_score	phy_score	coexp_score	go_score	total_score	dbs	pubs	exp_score	final_score
# Q13131	P14625	18.59	6.44772	18.59	4.2492	0.6153	2.416	9.4687	10.8	12008.4				12008.4
# P06400	Q96N96	1.8315	14.3222	14.3222	4.2492	0	2.416	2.1077	10.8	3346.93				3346.93
# Q7Z6V5	Q8NCE0	4.5712	0	4.5712	0	0	1.5978	9.4687	24.11	1667.4				1667.4
# P09661	Q13573	0	0	0	0	3.1392	0	1

# "prot1","prot2","str_score","protpep_score","str_max_score","red_score","ort_score","phy_score","coexp_score","go_score","total_score","dbs","pubs","exp_score","final_score"
# "Q13131","P14625","18.59","6.44772","18.59","4.2492","0.6153","2.416","9.4687","10.8","12008.4","","","","12008.4"
# "Q9Y2X7","Q9NPJ6","0","2.59","2.59","1.0145","0","2.416","1.5818","0","10.0415","BGDB|","pubmed:25281560|pubmed:25281575","957.82","9617.95"
# "Q9Y2X7","Q9NPJ6","0","2.59","2.59","1.0145","0","2.416","1.5818","0","10.0415","BGDB|","pubmed:25281560","957.82","9617.95"

#!/bin/bash

# Check if input file exist, download it if absent
if [ ! -f "data/preppi.csv" ]; then
    echo "data/preppi.csv does not exist, downloading."
    mkdir -p data && cd data
    ## Download preppi_final600.txt (30M compressed)
    wget -N https://honiglab.c2b2.columbia.edu/PrePPI/ref/preppi_final600.txt.tar.gz
    tar -xzvf *.tar.gz

    # Convert commas to | for ddbs column and PubMed publications CURIEs to URIs
    sed -e 's/,/|/g' -e 's/pubmed:/https:\/\/identifiers.org\/pubmed:/g' preppi_final600.txt > preppi.tsv

    # Convert TSV to CSV for RML Mapper
    sed -e 's/"//g' -e 's/\t/","/g' -e 's/^/"/' -e 's/$/"/' -e 's/\r//' preppi.tsv > preppi.csv

    # The next lines are used to produce a sample for development, comment them to process the complete files
    # mv disease-chemical.csv disease-chemical-full.csv
    # head -n 1000 disease-chemical-full.csv > disease-chemical.csv
    cd ..
fi

PROCESS_FILE="${1:-preppi-mapping.yarrr.yml}"

echo "Converting YARRRML mappings to RML"
yarrrml-parser -i $PROCESS_FILE -o data/mapping.rml.ttl


echo "Running RML mapper, output to data/ folder"
rm data/bio2kg-preppi.ttl
java -jar /opt/rmlmapper.jar -m data/mapping.rml.ttl -o data/bio2kg-preppi.ttl -s turtle -f ../functions_ids.ttl 

# head -n 40 data/bio2kg-preppi.ttl
