## Workflow

Check the GitHub Actions workflow file to run this process: `.github/workflows/process-interpro.yml`

## Run locally

Requirements: Java, `wget` (download manually on Windows)

* Run bash script to download `interpro` tsv file in this folder, and convert it to csv:

```bash
scripts/download.sh
```

> You can also manually download the file.

* Run Python preprocessing scripts to prepare data for the RML mapper (replace, generate ID column, etc):

```bash
python3 scripts/preprocessing.py
```

* Use [YARRRML Matey editor](https://rml.io/yarrrml/matey/) to test your YARRRML mappings, and convert them in RML mappings
* Store your RML mappings in the `.rml.ttl` file, and the YARRML mappings in the `.yarrr.yml` file
* Download the [`rmlmapper.jar`](https://github.com/RMLio/rmlmapper-java/releases) in your home folder to execute the RML mappings easily from anywhere:

```bash
wget -O ~/rmlmapper.jar https://github.com/RMLio/rmlmapper-java/releases/download/v4.9.1/rmlmapper-4.9.1.jar
```

* Run the RML mapper to generate RDF:

```bash
java -jar ~/rmlmapper.jar -m mapping/mappings.rml.ttl -o output/interpro.ttl
```

> YARRRML to RML mapping conversion can be automated using the [yarrrml-parser](https://github.com/RMLio/yarrrml-parser) GitHub Action