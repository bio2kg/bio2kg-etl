#!/bin/bash

# "prot1","prot2","str_score","protpep_score","str_max_score","red_score","ort_score","phy_score","coexp_score","go_score","total_score","dbs","pubs","exp_score","final_score"
# "Q13131","P14625","18.59","6.44772","18.59","4.2492","0.6153","2.416","9.4687","10.8","12008.4","","","","12008.4"
# "Q9Y2X7","Q9NPJ6","0","2.59","2.59","1.0145","0","2.416","1.5818","0","10.0415","BGDB|","pubmed:25281560|pubmed:25281575","957.82","9617.95"
# "Q9Y2X7","Q9NPJ6","0","2.59","2.59","1.0145","0","2.416","1.5818","0","10.0415","BGDB|","pubmed:25281560","957.82","9617.95"

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
fi

## The next lines are used to produce a sample for development, comment them to process the complete files
# mv disease-chemical.csv disease-chemical-full.csv
# head -n 1000 disease-chemical-full.csv > disease-chemical.csv