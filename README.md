ETL for the Bio2KG knowledge graph.

## Use GitHub Actions on the DSRI

You can define GitHub Actions workflows in the folder `.github/workflows` to run on the DSRI:

```yaml
jobs:
	your-job:
		runs-on: ["self-hosted", "dsri", "bio2kg" ]
		steps: ...
```

### Deploy a GitHub Actions runner

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

### Build the GitHub Actions runner

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

> Getting error with postgres:
>
> ```
> create Pod prefect-postgresql-0 in StatefulSet prefect-postgresql failed error: pods "prefect-postgresql-0" is forbidden: unable to validate against any security context constraint: 
> [provider restricted: .spec.securityContext.fsGroup: Invalid value: []int64{1001}: 1001 is not an allowed group spec.containers[0].securityContext.runAsUser: Invalid value: 1001: must be in the ranges: [1001810000, 1001819999]]
> ```

Uninstall:

```bash
helm uninstall prefect
```

### Run Prefect workflow

Register the test flow:

```bash
python3 datasets/workflow.py
# prefect run --name "bio2kg-etl"
```

## Deploy a Virtuoso triplestore

The [Virtuoso triplestore](https://hub.docker.com/r/openlink/virtuoso-opensource-7) deployment is defined in the `docker-compose.yml`. 

We use [nginx-proxy](https://github.com/nginx-proxy/nginx-proxy) to route the Virtuoso triplestore to a publicly available URL on our servers.

1. Change the `dba` user password in the `.env` file (default to `VIRTUOSO_PASSWORD=dba`)
2. Run a Virtuoso triplestore container:

```bash
docker-compose up -d
```

> Database files stored in `/data/bio2rdf5/virtuoso` on your machine. The path can be changed in the `docker-compose.yml`

3. Manage the triplestore data:

**Bulk load** `.nq` files in `/data/bio2rdf5/virtuoso/dumps` (on the server):

```bash
docker exec -it bio2kg-graph-virtuoso isql-v -U dba -P dba exec="ld_dir('/data/dumps', '*.nq', 'http://bio2rdf.org'); rdf_loader_run();"
```

**Check** bulk load in process:

```bash
docker exec -it bio2kg-graph-virtuoso isql-v -U dba -P dba exec="select * from DB.DBA.load_list;"
```

**Reset** the triplestore:

```bash
docker exec -it bio2kg-graph-virtuoso isql-v -U dba -P dba exec="RDF_GLOBAL_RESET ();"
```

**Configure Virtuoso**:

* Instructions to **enable CORS** for the SPARQL endpoint via the admin UI: http://vos.openlinksw.com/owiki/wiki/VOS/VirtTipsAndTricksCORsEnableSPARQLURLs

* Instructions to enable the **faceted browser** and **full text search** via the admin UI: http://vos.openlinksw.com/owiki/wiki/VOS/VirtFacetBrowserInstallConfig

* Enable LDP: https://github.com/vemonet/shapes-of-you#enable-virtuoso-linked-data-platform