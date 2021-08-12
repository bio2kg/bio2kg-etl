# ETL for the Bio2KG knowledge graph

[![Process HGNC](https://github.com/bio2kg/bio2kg-etl/actions/workflows/process-hgnc.yml/badge.svg)](https://github.com/bio2kg/bio2kg-etl/actions/workflows/process-hgnc.yml) [![Process DrugBank](https://github.com/bio2kg/bio2kg-etl/actions/workflows/process-drugbank.yml/badge.svg)](https://github.com/bio2kg/bio2kg-etl/actions/workflows/process-drugbank.yml) [![Process NCBIgene](https://github.com/bio2kg/bio2kg-etl/actions/workflows/process-ncbigene.yml/badge.svg)](https://github.com/bio2kg/bio2kg-etl/actions/workflows/process-ncbigene.yml) [![Process CTD](https://github.com/bio2kg/bio2kg-etl/actions/workflows/process-ctd.yml/badge.svg)](https://github.com/bio2kg/bio2kg-etl/actions/workflows/process-ctd.yml) [![Process STITCH](https://github.com/bio2kg/bio2kg-etl/actions/workflows/process-stitch.yml/badge.svg)](https://github.com/bio2kg/bio2kg-etl/actions/workflows/process-stitch.yml) [![Process HuRI](https://github.com/bio2kg/bio2kg-etl/actions/workflows/process-huri.yml/badge.svg)](https://github.com/bio2kg/bio2kg-etl/actions/workflows/process-huri.yml) [![Process SNAP BioData](https://github.com/bio2kg/bio2kg-etl/actions/workflows/process-snap-biodata.yml/badge.svg)](https://github.com/bio2kg/bio2kg-etl/actions/workflows/process-snap-biodata.yml)

## Run workflows locally

A GitHub Action workflow is defined to run each ETL workflow on DSRI. You can also easily run them locally (you might face scalability issues for some large dataset though). Checking a dataset workflow definition is a good way to see exactly the process to transform a dataset.

Checkout the `prepare_local.sh` script to see if you need to install additional packages like `wget` and `unzip`, and run it to install dependencies to run the ETL scripts locally:

```bash
./prepare_local.sh
```

Go to the folder of the dataset you want to process, e.g. to run `HGNC`:

```bash
cd datasets/HGNC
./run.sh
```

All temporary files are put in the `data/` folder

> If you are using Windows you will need to use [WSL](https://docs.microsoft.com/en-us/windows/wsl/install-win10) to run Bash scripts.

### Define mappings

1. Define a `run.sh` script to download the dataset, and run the RML mapper to generate the RDF. Use `datasets/HGNC` as starter for tabular files, or `datasets/DrugBank` for XML files.
2. You can browse existing SemanticScience classes and properties here: https://vemonet.github.io/semanticscience/browse/entities-tree-classes.html
3. You can add autocomplete and validation for YARRRML mappings files in VisualStudio Code easily:

Go to VisualStudio Code, open settings (`File` > `Preferences` > `Settings` or `Ctrl + ,`). After that, add the following lines to the `settings.json` 

```json
    "yaml.schemas": {
        "/path/to/folder/yarrrml.schema.json": ["*.yarrr.yml"]
    }
```

### Available RML mappers

1. rmlmapper-java: works well with CSV, XML and functions. But out of memory quickly for large files (e.g. DrugBank, iProClass)

2. RMLStreamer (scala): works well with large CSV. Not working with XML and functions (e.g. DrugBank, iProClass)

3. RocketRML (js): works well with medium size CSV and XML. Limit to 2G file to load. Face issues with some resolutions (e.g. PubMed)


See also: 

* https://github.com/SDM-TIB/SDM-RDFizer/wiki/Install&Run (check `datasets/CTD`)

* https://github.com/carml/carml: requires to rewrite a lot of things in Java 


## Run workflows on DSRI with GitHub Actions

You can define GitHub Actions workflows in the folder `.github/workflows` to run on the DSRI:

```yaml
jobs:
    your-job:
      runs-on: ["self-hosted", "dsri", "bio2kg" ]
      steps: ...
```

You can install anything you want with conda, pip, yarn, npm, maven.

### Build the GitHub Actions runner image

[![Publish Docker image](https://github.com/bio2kg/bio2kg-etl/actions/workflows/publish-runner-docker.yml/badge.svg)](https://github.com/bio2kg/bio2kg-etl/actions/workflows/publish-runner-docker.yml)

The latest version of [miniforge conda](https://github.com/conda-forge/miniforge/releases) is downloaded automatically.

Build:

```bash
docker build -t ghcr.io/bio2kg/workflow-runner:latest workflows
```

Quick try:

```bash
docker run -it --entrypoint=bash ghcr.io/bio2kg/workflow-runner:latest
```

Push:

```bash
docker push ghcr.io/bio2kg/workflow-runner:latest
```

### Start a GitHub Actions runner on DSRI

You can easily start a GitHub Actions workflow runner in your project on the DSRI:

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
    --set replicas=20 \
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

## Deploy a Virtuoso triplestore on DSRI

On the DSRI you can easily create a Virtuoso triplestore by using the dedicated template in the **Catalog**. 

You can also do it in one line from the command-line:

```bash
oc new-app virtuoso-triplestore -p PASSWORD=mypassword \
  -p APPLICATION_NAME=triplestore \
  -p STORAGE_SIZE=300Gi \
  -p DEFAULT_GRAPH=https://data.bio2kg.org/graph \
  -p TRIPLESTORE_URL=https://data.bio2kg.org/
```

After starting the Virtuoso triplestore you will need to install additional VAD packages and create the right folder to enable the Linked Data Platform features:

```bash
./prepare_virtuoso_dsri.sh
```

**Configure Virtuoso**:

* Instructions to **enable CORS** for the SPARQL endpoint via the admin UI: http://vos.openlinksw.com/owiki/wiki/VOS/VirtTipsAndTricksCORsEnableSPARQLURLs

* Instructions to enable the **faceted browser** and **full text search** via the admin UI: http://vos.openlinksw.com/owiki/wiki/VOS/VirtFacetBrowserInstallConfig

## Deploy the RMLStreamer on DSRI

Add or update the template in the `bio2kg` project:

```bash
oc apply -f https://raw.githubusercontent.com/vemonet/flink-on-openshift/master/template-flink-dsri.yml
```

Create the Flink cluster in your project on DSRI:

```bash
oc new-app apache-flink -p APPLICATION_NAME=flink \
  -p STORAGE_SIZE=500Gi \
  -p WORKER_COUNT="4" \
  -p TASKS_SLOTS="64" \
  -p CPU_LIMIT="32" \
  -p MEMORY_LIMIT=100Gi \
  -p FLINK_IMAGE="ghcr.io/maastrichtu-ids/rml-streamer:latest"
```

> Check [this repo](https://github.com/vemonet/flink-on-openshift) to build the image of Flink with the RMLStreamer.

Download the [latest release](https://github.com/RMLio/RMLStreamer/releases) of the `RMLStreamer.jar` file in the Flink cluster (to do only if not already present)

```bash
oc exec $(oc get pod --selector app=flink --selector component=jobmanager --no-headers -o=custom-columns=NAME:.metadata.name) -- bash -c "curl -s https://api.github.com/repos/RMLio/RMLStreamer/releases/latest | grep browser_download_url | grep .jar | cut -d '\"' -f 4 | wget -O /mnt/RMLStreamer.jar -qi -"
```

Submit a job:

```bash
export FLINK_POD=$(oc get pod --selector app=flink --selector component=jobmanager --no-headers -o=custom-columns=NAME:.metadata.name)

oc exec $FLINK_POD -- /opt/flink/bin/flink run -p 64 -c io.rml.framework.Main /opt/RMLStreamer.jar toFile -m /mnt/mapping.rml.ttl -o /mnt/bio2kg-output.nt --job-name "RMLStreamer Bio2KG - dataset"
```

See the Flink docs for more details on running jobs using the [CLI](https://ci.apache.org/projects/flink/flink-docs-release-1.13/docs/deployment/cli/) or [Kubernetes native execution](https://ci.apache.org/projects/flink/flink-docs-release-1.13/docs/deployment/resource-providers/native_kubernetes/).

cf. more Flink [docs for Kubernetes deployment](https://ci.apache.org/projects/flink/flink-docs-release-1.13/docs/deployment/resource-providers/standalone/kubernetes/)

Uninstall the Flink cluster from your project on DSRI:

```bash
oc delete all,secret,configmaps,serviceaccount,rolebinding --selector app=flink
# Delete the persistent volume:
oc delete pvc --selector app=flink
```

## Deploy Prefect workflows on DSRI

Experimental.

### Install Prefect server

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

### Run a Prefect workflow

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

## Run Argo workflows

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
