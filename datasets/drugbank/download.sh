#!/bin/bash

# Those values are defaults, you can set those environment variables in your environments
# export DRUGBANK_PASSWORD=yourpassword

[  -z "$DRUGBANK_USERNAME" ] && DRUGBANK_USERNAME="vincent.emonet@maastrichtuniversity.nl"
[  -z "$DRUGBANK_PASSWORD" ] && DRUGBANK_PASSWORD="maasitest12"
[  -z "$DRUGBANK_VERSION" ] && DRUGBANK_VERSION="5-1-8"

# Download full DrugBank dataset providing user login and password

if ! [ -e "data/drugbank.zip" ]; 
then 
    mkdir -p data
    echo "Downloading DrugBank file for version $DRUGBANK_VERSION"
    curl -Lfv -o data/drugbank.zip -u $DRUGBANK_USERNAME:$DRUGBANK_PASSWORD https://go.drugbank.com/releases/$DRUGBANK_VERSION/downloads/all-full-database

    # unzip data/*.zip -d .
else
    echo "full database.xml file exists. Delete it to download a new one"
fi

# Use DrugBank XML sample hosted on GitHub, faster for testing
# wget -N https://github.com/MaastrichtU-IDS/d2s-scripts-repository/raw/master/resources/drugbank-sample/drugbank.zip
# See the uncompressed file here: 
# https://github.com/MaastrichtU-IDS/d2s-scripts-repository/blob/master/resources/drugbank-sample/drugbank.xml

# mv "full database.xml" "drugbank_database.xml"