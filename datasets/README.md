## Folder content

In this folder you will find RML mappings and bash scripts to convert various kind of data to RDF:

* Entities from simple TSV: HGNC
* Associations from simple TSV: HuRI, PrePPI, snap-biodata
* Associations and entities from multiple TSV: PharmGKB, CTD
* Associations and entities from one large XML file: DrugBank
* Entities from multiple similar XML files: PubMed, ClinicalTrials 
* Entities from really large TSV file: iProClass (40G)
* SQL database: DrugCentral
* SPARQL: UniProt, WikiPathways

Datasets metadata experiment in `InterPro`

## To do

Improve the download of new files to properly detect when there is a new version

Running an ETL workflow should be handled by a small program (python?) which will, for each dataset:

1. Query the triplestore (metadata graphs) to retrieve the last time the dataset has been updated, for each file in the dataset (or version number if possible)
2. Check last modified date on server, or version number, don't run if not new
3. Automatically generate a new version number based on previous versions, if applicable, and automatically check the new URL?
4. Compare schema? XSD/DTD for XML

We need to register how to download each file in the dataset metadata

### d2s run

Working for following datasets:

* BioSNAP
* DrugCentral

## Notes

Some RML mappings have been reused from https://doi.org/10.5281/zenodo.3552369

cf. tool used to implement the mappings as ODBA: https://github.com/oeg-upm/morph-csv

