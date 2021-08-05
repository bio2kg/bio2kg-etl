# ETL for the Bio2KG knowledge graph

[![Process DrugBank](https://github.com/bio2kg/bio2kg-etl/actions/workflows/process-drugbank.yml/badge.svg)](https://github.com/bio2kg/bio2kg-etl/actions/workflows/process-drugbank.yml) [![Process HGNC](https://github.com/bio2kg/bio2kg-etl/actions/workflows/process-hgnc.yml/badge.svg)](https://github.com/bio2kg/bio2kg-etl/actions/workflows/process-hgnc.yml)

## Use GitHub Actions on the DSRI

You can define GitHub Actions workflows in the folder `.github/workflows` to run on the DSRI:

```yaml
jobs:
    your-job:
      runs-on: ["self-hosted", "dsri", "bio2kg" ]
      steps: ...
```

You can install anything you want with conda, pip, yarn, npm, maven.

### Build the GitHub Actions runner image

For the latest miniforge conda versions, checkout https://github.com/conda-forge/miniforge/releases

Build:

```bash
docker build --build-arg conda_version=4.10.3 --build-arg miniforge_python=Mambaforge -t ghcr.io/bio2kg/workflow-runner:latest .
```

Quick try:

```bash
docker run -it --entrypoint=bash ghcr.io/bio2kg/workflow-runner:latest
```

Push:

```bash
docker push ghcr.io/bio2kg/workflow-runner:latest
```

### Deploy a GitHub Actions runner on the DSRI

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
    --set replicas=3 \
    --set serviceAccountName=anyuid \
    --set memoryRequest="512Mi" \
    --set memoryLimit="100Gi" \
    --set cpuRequest="100m" \
    --set cpuLimit="60" \
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

Create the Flink cluster:

```bash
oc new-app apache-flink -p APPLICATION_NAME=flink \
  -p STORAGE_SIZE=100Gi \
  -p WORKER_COUNT="4" \
  -p TASKS_SLOTS="64" \
  -p CPU_LIMIT="32" \
  -p MEMORY_LIMIT=60Gi \
  -p FLINK_IMAGE="flink:1.12.3-scala_2.11"
```

Download the [latest release](https://github.com/RMLio/RMLStreamer/releases) of the `RMLStreamer.jar` file in the Flink cluster (to do only if not already present)

```bash
oc exec $(oc get pod --selector app=flink --selector component=jobmanager --no-headers -o=custom-columns=NAME:.metadata.name) -- bash -c "curl -s https://api.github.com/repos/RMLio/RMLStreamer/releases/latest | grep browser_download_url | grep .jar | cut -d '\"' -f 4 | wget -O /mnt/RMLStreamer.jar -qi -"
```

Submit a job:

```bash
export FLINK_POD=$(oc get pod --selector app=flink --selector component=jobmanager --no-headers -o=custom-columns=NAME:.metadata.name)
export PARALLELISM=64

oc exec $FLINK_POD -- /opt/flink/bin/flink run --detached -p $PARALLELISM -c io.rml.framework.Main /opt/RMLStreamer.jar toFile -m /mnt/input.csv -o /mnt/output.nt --job-name "RMLStreamer Bio2KG - dataset"
```

See the Flink docs for more details on running jobs using the [CLI](https://ci.apache.org/projects/flink/flink-docs-release-1.13/docs/deployment/cli/) or [Kubernetes native execution](https://ci.apache.org/projects/flink/flink-docs-release-1.13/docs/deployment/resource-providers/native_kubernetes/).

cf. more Flink [docs for Kubernetes deployment](https://ci.apache.org/projects/flink/flink-docs-release-1.13/docs/deployment/resource-providers/standalone/kubernetes/)

## Deploy Prefect workflows

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

### Run Prefect workflow

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
