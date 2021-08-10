
oc project my-project
export GITHUB_PAT="TOKEN"
export GITHUB_OWNER=bio2kg

helm install actions-runner openshift-actions-runner/actions-runner \
    --set-string githubPat=$GITHUB_PAT \
    --set-string githubOwner=$GITHUB_OWNER \
    --set runnerLabels="{ dsri, $GITHUB_OWNER }" \
    --set replicas=100 \
    --set serviceAccountName=anyuid \
    --set memoryRequest="512Mi" \
    --set memoryLimit="100Gi" \
    --set cpuRequest="100m" \
    --set cpuLimit="60"

# Stop: 
# helm uninstall actions-runner