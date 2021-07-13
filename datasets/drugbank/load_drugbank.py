import logging as log
import datetime
import sys

import os
import csv
import gzip
import collections
import re
import io
import json
import xml.etree.ElementTree as ET
import pandas
import zipfile

start_time = datetime.datetime.now()
os.makedirs('data', exist_ok=True)
log.basicConfig(filename='data/run.log', filemode='w', level=log.DEBUG,
    datefmt='%Y-%m-%d %H:%M:%S', format='%(asctime)s %(levelname)-8s %(message)s')
log.getLogger().addHandler(log.StreamHandler(sys.stdout))

# Set those variables as GitHub secrets for the workflow
drugbank_username = os.getenv('DRUGBANK_USERNAME', 'vincent.emonet@maastrichtuniversity.nl')
drugbank_password = os.getenv('DRUGBANK_PASSWORD', 'changepassword')
drugbank_version = os.getenv('DRUGBANK_VERSION', '5-1-8')
if not os.path.isfile('data/drugbank.zip'):
    log.info('drugbank.xml not present, downloading it')
    os.system('curl -Lfs -o data/drugbank.zip -u ' + drugbank_username + ':' + drugbank_password + ' https://go.drugbank.com/releases/' + drugbank_version + '/downloads/all-full-database')

log.info('💽 Loading the drugbank.zip file')

zip_path = os.path.join('data', 'drugbank.zip')
archive = zipfile.ZipFile(zip_path, 'r')

with archive.open('full database.xml', 'r') as xml_file:
    log.info('Zip loaded, parsing the XML...')
    tree = ET.parse(xml_file)
    
root = tree.getroot()

ns = '{http://www.drugbank.ca}'
inchikey_template = "{ns}calculated-properties/{ns}property[{ns}kind='InChIKey']/{ns}value"
inchi_template = "{ns}calculated-properties/{ns}property[{ns}kind='InChI']/{ns}value"

rows = list()
for i, drug in enumerate(root):
    row = collections.OrderedDict()
    assert drug.tag == ns + 'drug'
    row['type'] = drug.get('type')
    row['drugbank_id'] = drug.findtext(ns + "drugbank-id[@primary='true']")
    row['name'] = drug.findtext(ns + "name")
    row['description'] = drug.findtext(ns + "description")
    row['groups'] = [group.text for group in
        drug.findall("{ns}groups/{ns}group".format(ns = ns))]
    row['atc_codes'] = [code.get('code') for code in
        drug.findall("{ns}atc-codes/{ns}atc-code".format(ns = ns))]
    row['categories'] = [x.findtext(ns + 'category') for x in
        drug.findall("{ns}categories/{ns}category".format(ns = ns))]
    row['inchi'] = drug.findtext(inchi_template.format(ns = ns))
    row['inchikey'] = drug.findtext(inchikey_template.format(ns = ns))
    
    # Add drug aliases
    aliases = {
        elem.text for elem in 
        drug.findall("{ns}international-brands/{ns}international-brand".format(ns = ns)) +
        drug.findall("{ns}synonyms/{ns}synonym[@language='English']".format(ns = ns)) +
        drug.findall("{ns}international-brands/{ns}international-brand".format(ns = ns)) +
        drug.findall("{ns}products/{ns}product/{ns}name".format(ns = ns))

    }
    aliases.add(row['name'])
    row['aliases'] = sorted(aliases)

    rows.append(row)

alias_dict = {row['drugbank_id']: row['aliases'] for row in rows}
# with open('./data/aliases.json', 'w') as fp:
#     json.dump(alias_dict, fp, indent=2, sort_keys=True)

def collapse_list_values(row):
    for key, value in row.items():
        if isinstance(value, list):
            row[key] = '|'.join(value)
    return row

rows = list(map(collapse_list_values, rows))

columns = ['drugbank_id', 'name', 'type', 'groups', 'atc_codes', 'categories', 'inchikey', 'inchi', 'description']
drugbank_df = pandas.DataFrame.from_dict(rows)[columns]

print(drugbank_df.head())

drugbank_df.to_csv('data/drugbank_processed.csv')

run_time = datetime.datetime.now() - start_time
log.info('Ran for ' + str(run_time))