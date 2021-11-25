#!/bin/bash

unzip -o drugbank.zip
# Replace <drugbank-id @primary=true> by <drugbank-id-primary> to enable RML to get the main DrugBank ID
sed -r 's/<drugbank-id primary="true">(.*)<\/drugbank-id>/<drugbank-id-primary>\1<\/drugbank-id-primary>/g' full\ database.xml > drugbank.xml
