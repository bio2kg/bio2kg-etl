# ETL for the Bio2KG knowledge graph


| Entities                                                     | ETL workflows on DSRI                                        |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| [Genes](https://vemonet.github.io/semanticscience/browse/class-siogene.html) | [![Process HGNC](https://github.com/bio2kg/bio2kg-etl/actions/workflows/process-hgnc.yml/badge.svg)](https://github.com/bio2kg/bio2kg-etl/actions/workflows/process-hgnc.yml)  [![Process NCBIgene](https://github.com/bio2kg/bio2kg-etl/actions/workflows/process-ncbigene.yml/badge.svg)](https://github.com/bio2kg/bio2kg-etl/actions/workflows/process-ncbigene.yml) [![Process Homologene](https://github.com/bio2kg/bio2kg-etl/actions/workflows/process-homologene.yml/badge.svg)](https://github.com/bio2kg/bio2kg-etl/actions/workflows/process-homologene.yml) [![Process GenAge](https://github.com/bio2kg/bio2kg-etl/actions/workflows/process-genage.yml/badge.svg)](https://github.com/bio2kg/bio2kg-etl/actions/workflows/process-genage.yml) [![GenDR](https://github.com/bio2kg/bio2kg-etl/actions/workflows/process-gendr.yml/badge.svg)](https://github.com/bio2kg/bio2kg-etl/actions/workflows/process-gendr.yml) |
| [Drugs](https://vemonet.github.io/semanticscience/browse/class-siodrug.html) | [![Process DrugBank](https://github.com/bio2kg/bio2kg-etl/actions/workflows/process-drugbank.yml/badge.svg)](https://github.com/bio2kg/bio2kg-etl/actions/workflows/process-drugbank.yml) [![DrugCentral](https://github.com/bio2kg/bio2kg-etl/actions/workflows/process-drugcentral.yml/badge.svg)](https://github.com/bio2kg/bio2kg-etl/actions/workflows/process-drugcentral.yml) [![PharmGKB](https://github.com/bio2kg/bio2kg-etl/actions/workflows/process-pharmgkb.yml/badge.svg)](https://github.com/bio2kg/bio2kg-etl/actions/workflows/process-pharmgkb.yml) |
| [Proteins](https://vemonet.github.io/semanticscience/browse/class-sioprotein.html) | [![Process iProClass](https://github.com/bio2kg/bio2kg-etl/actions/workflows/process-iproclass.yml/badge.svg)](https://github.com/bio2kg/bio2kg-etl/actions/workflows/process-iproclass.yml) |
| [Publications](https://vemonet.github.io/semanticscience/browse/class-siopeerreviewedarticle.html) | [![PubMed](https://github.com/bio2kg/bio2kg-etl/actions/workflows/process-pubmed.yml/badge.svg)](https://github.com/bio2kg/bio2kg-etl/actions/workflows/process-pubmed.yml) [![ClinicalTrials](https://github.com/bio2kg/bio2kg-etl/actions/workflows/process-clinicaltrials.yml/badge.svg)](https://github.com/bio2kg/bio2kg-etl/actions/workflows/process-clinicaltrials.yml) |
| [Associations](https://vemonet.github.io/semanticscience/browse/class-sioassociation.html) | [![Process CTD](https://github.com/bio2kg/bio2kg-etl/actions/workflows/process-ctd.yml/badge.svg)](https://github.com/bio2kg/bio2kg-etl/actions/workflows/process-ctd.yml) [![iRefIndex](https://github.com/bio2kg/bio2kg-etl/actions/workflows/process-irefindex.yml/badge.svg)](https://github.com/bio2kg/bio2kg-etl/actions/workflows/process-irefindex.yml) [![Process STITCH](https://github.com/bio2kg/bio2kg-etl/actions/workflows/process-stitch.yml/badge.svg)](https://github.com/bio2kg/bio2kg-etl/actions/workflows/process-stitch.yml) [![Process HuRI](https://github.com/bio2kg/bio2kg-etl/actions/workflows/process-huri.yml/badge.svg)](https://github.com/bio2kg/bio2kg-etl/actions/workflows/process-huri.yml) [![Process BioSNAP](https://github.com/bio2kg/bio2kg-etl/actions/workflows/process-biosnap.yml/badge.svg)](https://github.com/bio2kg/bio2kg-etl/actions/workflows/process-biosnap.yml) |

## Run workflows locally

A GitHub Action workflow is defined to run each ETL workflow on DSRI. You can also easily run them locally (you might face scalability issues for some large datasets though, so try to use a sample for testing). Checking a dataset workflow definition is a good way to see exactly the process to convert this dataset to RDF using the SemanticScience ontology.

> If you are using Windows you will need to use [WSL](https://docs.microsoft.com/en-us/windows/wsl/install-win10) to run Bash scripts (even when using the python library).

Checkout the `prepare_local.sh` script to see if you need to install additional packages like `wget` and `unzip`, and run it to install dependencies to run the ETL scripts locally:

```bash
./prepare_local.sh
```

Go to the folder of the dataset you want to process, and use `d2s` to run the dataset processing based on its `metadata.ttl` file: e.g. to run `HGNC`:

```bash
cd datasets/HGNC
d2s run --sample 100
```

All temporary files are put in the `data/` folder


If you face conflicts with already installed packages, then you might want to use a [Virtual Environment](https://docs.python.org/3/tutorial/venv.html) to isolate the installation in the current folder before installing `d2s`:

```bash
# Create the virtual environment folder in your workspace
python3 -m venv .venv
# Activate it using a script in the created folder
source .venv/bin/activate
```

### Define mappings

Add autocomplete and validation for YARRRML mappings files and the `d2s.yml` config file in VisualStudio Code easily with the [YAML extension from RedHat](https://marketplace.visualstudio.com/items?itemName=redhat.vscode-yaml). Go to VisualStudio Code, open settings (`File` > `Preferences` > `Settings` or `Ctrl + ,`). Then add the following lines to the `settings.json` :

```json
    "yaml.schemas": {
        "https://raw.githubusercontent.com/bio2kg/bio2kg-etl/main/resources/yarrrml.schema.json": ["*.yarrr.yml"],
        "https://raw.githubusercontent.com/d2s/d2s-cli/master/resources/d2s-config.schema.json": ["d2s.yml"],
    }
```

To process a new dataset create a new folder in the `datasets` folder, and add the following files to map the dataset to RDF:

1. Define a `dataset-yourdataset.ttl` or `dataset-yourdataset.jsonld` file to describe your dataset, the files to download and potential preprocessing script to run.
2. Optionally define a `prepare.sh` script to perform specification preparation steps on the dataset.
3. Define a `mapping-yourdataset.yarrr.yml` file to map the dataset to the [SemanticScience ontology](https://vemonet.github.io/semanticscience/browse/entities-tree-classes.html) following the Bio2KG model.  You can use [YARRRML Matey editor](https://rml.io/yarrrml/matey/) to write and test your YARRRML mappings.

Use `datasets/HGNC` as starter for tabular files, or `datasets/InterPro` for XML files.

### Available RML mappers

Multiple solutions are available to generate RDF from RML mappings:

1. [rmlmapper-java](https://github.com/RMLio/rmlmapper-java): the reference implementation, works well with CSV, XML and functions. But out of memory quickly for large files (e.g. DrugBank, iProClass)

2. [RMLStreamer](https://github.com/RMLio/RMLStreamer) (scala): works well with large CSV and XML files. Not working with functions (e.g. DrugBank, iProClass)

3. [RocketRML](https://github.com/semantifyit/RocketRML) (js): works well with medium size CSV (2G max) and XML. Easy to define new functions in JavaScript (no need to rebuild the jar and add turtle files). But faces issues when running in the workflow runner (missing `make` for `pugixml`). See `datasets/DrugBank` or `datasets/iProClass`.


See also: 

* [SDM-RDFizer](https://github.com/SDM-TIB/SDM-RDFizer/wiki/Install&Run): work started in `datasets/CTD`

* [CARML](https://github.com/carml/carml): can't be used as executable apparently, requires to write a java program

### Run in a docker container

Still work in progress

Build:

```bash
docker build -t ghcr.io/bio2kg/d2s-runner:latest -f Dockerfile .
```

Run:

```bash
docker run -it --entrypoint bash -v $(pwd):/data ghcr.io/bio2kg/d2s-runner:latest
```

## Deploy services on the DSRI

### Start Virtuoso triplestores on DSRI

On the DSRI you can easily create Virtuoso triplestores by using the dedicated template in the **Catalog** (cf. this docs for [Virtuoso LDP](https://github.com/vemonet/virtuoso-ldp))

First define the password as environment variable:

```bash
export DBA_PASSWORD=yourpassword
```

Start the production triplestore:

```bash
oc new-app virtuoso-triplestore -p PASSWORD=$DBA_PASSWORD \
  -p APPLICATION_NAME=triplestore \
  -p STORAGE_SIZE=300Gi \
  -p DEFAULT_GRAPH=https://data.bio2kg.org/graph \
  -p TRIPLESTORE_URL=triplestore-bio2kg.apps.dsri2.unimaas.nl
```

Start the staging triplestore:

```bash
oc new-app virtuoso-triplestore -p PASSWORD=$DBA_PASSWORD \
  -p APPLICATION_NAME=staging \
  -p STORAGE_SIZE=300Gi \
  -p DEFAULT_GRAPH=https://data.bio2kg.org/graph \
  -p TRIPLESTORE_URL=triplestore-bio2kg.apps.dsri2.unimaas.nl
```

After starting the Virtuoso triplestores you will need to install additional VAD packages and create the right folder to enable the Linked Data Platform features:

```bash
./prepare_virtuoso_dsri.sh triplestore
./prepare_virtuoso_dsri.sh staging
```

**Configure Virtuoso**:

* Instructions to **enable CORS** for the SPARQL endpoint via the admin UI: http://vos.openlinksw.com/owiki/wiki/VOS/VirtTipsAndTricksCORsEnableSPARQLURLs

* Instructions to enable the **faceted browser** and **full text search** via the admin UI: http://vos.openlinksw.com/owiki/wiki/VOS/VirtFacetBrowserInstallConfig

Delete a triplestore on DSRI:

```bash
oc delete all,secret,configmaps,serviceaccount,rolebinding --selector app=staging
oc delete all,secret,configmaps,serviceaccount,rolebinding --selector app=triplestore
# Delete the persistent volume:
oc delete pvc --selector app=staging
oc delete pvc --selector app=triplestore
```

### Start the RMLStreamer on DSRI

Add or update the template in the `bio2kg` project on the DSRI:

```bash
oc apply -f https://raw.githubusercontent.com/vemonet/flink-on-openshift/master/template-flink-dsri.yml
```

Create the Flink cluster in your project on DSRI:

```bash
oc new-app apache-flink -p APPLICATION_NAME=flink \
  -p PASSWORD=$DBA_PASSWORD \
  -p STORAGE_SIZE=1Ti \
  -p WORKER_COUNT="4" \
  -p TASKS_SLOTS="64" \
  -p CPU_LIMIT="32" \
  -p MEMORY_LIMIT=100Gi \
  -p LOG_LEVEL=DEBUG \
  -p FLINK_IMAGE="ghcr.io/maastrichtu-ids/rml-streamer:latest"
  # -p FLINK_IMAGE="flink:1.12.3-scala_2.11"
```

> Check [this repo](https://github.com/vemonet/flink-on-openshift) to build the image of Flink with the RMLStreamer.

Clone the repository with all datasets mappings in `/mnt` in the RMLStreamer:

```bash
oc exec $(oc get pod --selector app=flink --selector component=jobmanager --no-headers -o=custom-columns=NAME:.metadata.name) -- bash -c "cd /mnt && git clone https://github.com/bio2kg/bio2kg-etl.git && mv {bio2kg-etl/*,bio2kg-etl/.*} . && rmdir bio2kg-etl"

oc exec $(oc get pod --selector app=flink --selector component=jobmanager --no-headers -o=custom-columns=NAME:.metadata.name) -- git clone https://github.com/bio2kg/bio2kg-etl.git 
```

Download the [latest release](https://github.com/RMLio/RMLStreamer/releases) of the `RMLStreamer.jar` file in the `/mnt` folder in the Flink cluster (to do only if not already present)

```bash
oc exec $(oc get pod --selector app=flink --selector component=jobmanager --no-headers -o=custom-columns=NAME:.metadata.name) -- bash -c "curl -s https://api.github.com/repos/RMLio/RMLStreamer/releases/latest | grep browser_download_url | grep .jar | cut -d '\"' -f 4 | wget -O /mnt/RMLStreamer.jar -qi -"
```

Submit a job with the CLI:

```bash
export FLINK_POD=$(oc get pod --selector app=flink --selector component=jobmanager --no-headers -o=custom-columns=NAME:.metadata.name)

oc exec $FLINK_POD -- /opt/flink/bin/flink run -p 64 -c io.rml.framework.Main /opt/RMLStreamer.jar toFile -m /mnt/mapping.rml.ttl -o /mnt/bio2kg-output.nt --job-name "RMLStreamer Bio2KG - dataset"
```

> See the Flink docs for more details on running jobs using the [CLI](https://ci.apache.org/projects/flink/flink-docs-release-1.13/docs/deployment/cli/) or [Kubernetes native execution](https://ci.apache.org/projects/flink/flink-docs-release-1.13/docs/deployment/resource-providers/native_kubernetes/). And more Flink [docs for Kubernetes deployment](https://ci.apache.org/projects/flink/flink-docs-release-1.13/docs/deployment/resource-providers/standalone/kubernetes/)

Submit a job with the UI (not working):

* `io.rml.framework.Main`
* `toFile -m /mnt/datasets/iProClass/data/iproclass-mapping.rml.ttl -o /mnt/datasets/iProClass/output/output.nt`

[Upload a jar file with the API](https://ci.apache.org/projects/flink/flink-docs-release-1.3/monitoring/rest_api.html#submitting-programs):

```bash
curl -X POST -F jarfile=@RMLStreamer.jar flink-jobmanager-rest:8081/jars/upload
curl flink-jobmanager-rest:8081/jars
```

Run the jar previously uploaded (not working):

```bash
curl -X POST flink-jobmanager-rest:8081/jars/b61e9ca3-ca5b-437f-bfe5-59661ed5826c_RMLStreamer.jar/run?parallelism=4&entry-class=io.rml.framework.Main&program-args=toFile -m /mnt/datasets/iProClass/data/iproclass-mapping.rml.ttl -o /mnt/datasets/iProClass/output/output.nt
```

Returns error: ` {"errors":["org.apache.flink.runtime.rest.handler.RestHandlerException: No jobs included in application.`

Docs for Flink API:

* https://ci.apache.org/projects/flink/flink-docs-release-1.3/monitoring/rest_api.html#submitting-programs
* https://ci.apache.org/projects/flink/flink-docs-release-1.13/docs/ops/rest_api/

Uninstall the Flink cluster from your project on DSRI:

```bash
oc delete all,secret,configmaps,serviceaccount,rolebinding --selector app=flink
# Delete also the persistent volume:
oc delete pvc,all,secret,configmaps,serviceaccount,rolebinding --selector app=flink
```

## Run workflows on DSRI 

### With GitHub Actions

You can define GitHub Actions workflows YAML files in the folder `.github/workflows` to run on the DSRI:

```yaml
jobs:
    your-job:
      runs-on: ["self-hosted", "dsri", "bio2kg" ]
      steps: ...
```

You can install anything you want with conda, pip, yarn, npm, maven.

#### Build the GitHub Actions runner image

[![Publish Docker image](https://github.com/bio2kg/bio2kg-etl/actions/workflows/publish-runner-docker.yml/badge.svg)](https://github.com/bio2kg/bio2kg-etl/actions/workflows/publish-runner-docker.yml)

The workflow-runner image is built and publish at every change to `workflows/Dockerfile` by a GitHub Actions workflow.

Build with the latest version of [miniforge conda](https://github.com/conda-forge/miniforge/releases) automatically downloaded:

```bash
docker build -t ghcr.io/bio2kg/workflow-runner:latest -f workflows/Dockerfile .
```

Quick try:

```bash
docker run -it --entrypoint=bash ghcr.io/bio2kg/workflow-runner:latest
```

Push:

```bash
docker push ghcr.io/bio2kg/workflow-runner:latest
```

#### Start a GitHub Actions runner on DSRI

You can easily start a GitHub Actions workflow runner in your project on the DSRI using the [Actions runner Helm chart](https://github.com/redhat-actions/openshift-actions-runner-chart):

1. Get an access token with a user in the bio2kg organization, and export it in your environment

```bash
export GITHUB_PAT="TOKEN"
```

2. Go to your project on the DSRI

```bash
oc project bio2kg
```

3. Start the runners in your project

```bash
helm install actions-runner openshift-actions-runner/actions-runner \
    --set-string githubPat=$GITHUB_PAT \
    --set-string githubOwner=bio2kg \
    --set runnerLabels="{ dsri, bio2kg }" \
    --set replicas=40 \
    --set serviceAccountName=anyuid \
    --set memoryRequest="512Mi" \
    --set memoryLimit="200Gi" \
    --set cpuRequest="100m" \
    --set cpuLimit="128" \
    --set runnerImage=ghcr.io/bio2kg/workflow-runner \
    --set runnerTag=latest
```

4. Check the runners are available from GitHub: go to your organization **Settings** page on GitHub, then go to the **Actions** tab, click go to the **Runner** tab, and scroll to the bottom. In the list of active runners you should see the runners you just deployed. 

Uninstall:

```bash
helm uninstall actions-runner
```

### Deploy Airflow on DSRI

Some relevant resources:

* [Official Helm chart for Airflow docs](https://airflow.apache.org/docs/helm-chart/stable/index.html)
* [Official Helm chart source code](https://github.com/apache/airflow/tree/main/chart)
* [Official Helm chart parameters](https://airflow.apache.org/docs/helm-chart/stable/parameters-ref.html)

Install the official Airflow Helm chart:

```bash
helm repo add apache-airflow https://airflow.apache.org
helm repo update
```

Deploy airflow with dags synchronized with this GitHub repository `workflows/dags` folder (cf. `workflows/airflow-helm-values.yaml` for all deployment settings):

```bash
helm install airflow apache-airflow/airflow \
    -f workflows/airflow-helm-values.yaml \
    --set webserver.defaultUser.password=$DBA_PASSWORD
```

Fix the postgresql deployment (because setting the `serviceAccount.name` of the sub chart `postgresql` don't work, but should be possible according to the [official helm docs](https://helm.sh/docs/chart_template_guide/subcharts_and_globals/)):

```bash
oc patch statefulset/airflow-postgresql --patch '{"spec":{"template":{"spec": {"serviceAccountName": "anyuid"}}}}'
```

To access it you can forward the webserver on your machine http://localhost:8080

```bash
oc port-forward svc/airflow-webserver 8080
```

Or expose the service on a URL (accessible when on the UM VPN) with HTTPS enabled:

```bash
oc expose svc/airflow-webserver
oc patch route/airflow-webserver --patch '{"spec":{"tls": {"termination": "edge", "insecureEdgeTerminationPolicy": "Redirect"}}}'
```

> If you try to use a different database for production, you can use this on the DSRI: 
>
> ```bash
> oc new-app postgresql-persistent \
>   -p DATABASE_SERVICE_NAME=airflow-postgresql \
>   -p POSTGRESQL_DATABASE=airflow \
>   -p POSTGRESQL_USER=postgres \
>   -p POSTGRESQL_PASSWORD=$DBA_PASSWORD \
>   -p VOLUME_CAPACITY=20Gi \
>   -p MEMORY_LIMIT=1Gi \
>   -p POSTGRESQL_VERSION="10-el8"
> ```
>
> But getting error due to the fact that the service is not directly part of the helm release (which shows the  [doc to deploy in production](https://airflow.apache.org/docs/helm-chart/stable/production-guide.html) is wrong, and the chart poorly written): 
>
> ```bash
> Error: rendered manifests contain a resource that already exists. Unable to continue with install: 
> Service "airflow-postgresql" in namespace "bio2kg" exists and cannot be imported into the current release: invalid ownership metadata; label validation error: 
> missing key "app.kubernetes.io/managed-by": must be set to "Helm"; annotation validation error: missing key "meta.helm.sh/release-name": must be set to "airflow"
> ```

Delete:

```bash
helm uninstall airflow
```

### Deploy Prefect workflows on DSRI

Experimental.

#### Install Prefect server

See docs to [install Prefect Server on Kubernetes](https://github.com/PrefectHQ/server/tree/master/helm/prefect-server)

```bash
helm repo add prefecthq https://prefecthq.github.io/server/
helm repo update
```

Install Prefect in your project (`oc project my-project`) on OpenShift:

```bash
helm install prefect prefecthq/prefect-server \
    --set agent.enabled=true \
    --set jobs.createTenant.enabled=true \
    --set serviceAccount.create=false --set serviceAccount.name=anyuid \
    --set postgresql.useSubChart=true \
    --set postgresql.serviceAccount.name=anyuid \
    --set ui.apolloApiUrl=http://prefect-graphql-bio2kg.apps.dsri2.unimaas.nl/graphql
```

Run this to fix the postgres error:

```bash
oc patch statefulsets/prefect-postgresql --patch '{"spec":{"template": {"spec": {"serviceAccountName": "anyuid"}}}}'
```

Change a settings in a running Prefect server:

```bash
helm upgrade prefect prefecthq/prefect-server \
	--set ui.apolloApiUrl=http://prefect-graphql-bio2kg.apps.dsri2.unimaas.nl/graphql 
```

Uninstall:

```bash
helm uninstall prefect
```

#### Run a Prefect workflow

On your laptop, change the host in the configuration file `~/.prefect/config.toml` (cf. [docs](https://github.com/PrefectHQ/server/tree/master/helm/prefect-server#connecting-to-your-server))

```toml
[server]
  host = "http://prefect-graphql-bio2kg.apps.dsri2.unimaas.nl"
  port = 80
```

Create the project (if not already existing)

```bash
prefect create project 'bio2kg'
```

Register a workflow:

```bash
python3 workflows/prefect-workflow.py
```

### Deploy Argo workflows on DSRI

[Install Argo workflows](https://github.com/argoproj/argo-helm/tree/master/charts/argo-workflows) using Helm charts:

```bash
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
```

Start Argo workflows in the current project on DSRI:

```bash
helm install argo-workflows argo/argo-workflows \
    --set workflow.serviceAccount.create=true \
    --set workflow.serviceAccount.rbac.create=true \
    --set workflow.serviceAccount.name="anyuid" \
    --set controller.serviceAccount.create=true \
    --set controller.serviceAccount.rbac.create=true \
    --set controller.serviceAccount.name="anyuid" \
    --set server.serviceAccount.create=true \
    --set server.serviceAccount.rbac.create=true \
    --set server.serviceAccount.name="anyuid" 
```

Delete Argo workflows:

```bash
helm uninstall argo-workflows 
```

Maybe fix with [adding SCC for hostpath](https://docs.openshift.com/container-platform/3.11/admin_guide/manage_scc.html#use-the-hostpath-volume-plugin)

## Credits

We reused some RML mappings from this publication: https://doi.org/10.5281/zenodo.3552369

