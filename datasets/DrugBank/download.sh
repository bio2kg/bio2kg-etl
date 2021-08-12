#!/bin/bash

# Allow to provide drugbank login via args or env variables
DRUGBANK_USERNAME="${1:-$DRUGBANK_USERNAME}"
DRUGBANK_USERNAME="${2:-$DRUGBANK_PASSWORD}"

DRUGBANK_VERSION="${DRUGBANK_VERSION:=5-1-8}"

if [ ! -f "data/drugbank.xml" ]; then
    echo "data/drugbank.xml does not exist, downloading version $DRUGBANK_VERSION"
    mkdir -p data
    cd data
    curl -Lfs -o drugbank.zip -u $DRUGBANK_USERNAME:$DRUGBANK_PASSWORD https://go.drugbank.com/releases/$DRUGBANK_VERSION/downloads/all-full-database
    unzip drugbank.zip
    # Replace <drugbank-id @primary=true> by <drugbank-id-primary> to enable RML to get the main DrugBank ID
    sed -r 's/<drugbank-id primary="true">(.*)<\/drugbank-id>/<drugbank-id-primary>\1<\/drugbank-id-primary>/g' full\ database.xml > drugbank.xml

    # Fix a namespace causing RMLStreamer to fail
    # sed -ir 's/xsi:schemaLocation="http:\/\/www.drugbank.ca /xsi:schemaLocation="/' drugbank.xml
    sed -ir 's/ version="5\.1" exported-on="2021-01-03"//' drugbank.xml
fi

# npm install rocketrml