

# export DBA_PASSWORD=$1
export DBA_PASSWORD=$(cat .env | grep VIRTUOSO_PASSWORD | sed 's/VIRTUOSO_PASSWORD=//g')

oc project bio2kg

pod_id=$(oc get pod --selector app=triplestore --no-headers -o=custom-columns=NAME:.metadata.name)
echo "Preparing Pod on the DSRI with ID: $pod_id"

# Install wget and download VAD packages in Virtuoso container
oc exec $pod_id -- apt-get update
oc exec $pod_id -- apt-get install -y wget
oc exec $pod_id -- wget -N http://download3.openlinksw.com/uda/vad-vos-packages/7.2/ods_framework_dav.vad
oc exec $pod_id -- wget -N http://download3.openlinksw.com/uda/vad-vos-packages/7.2/ods_briefcase_dav.vad

# Install VAD packages: http://docs.openlinksw.com/virtuoso/dbadm/
oc exec $pod_id -- isql -U dba -P $DBA_PASSWORD exec="vad_install ('ods_framework_dav.vad', 0);"
oc exec $pod_id -- isql -U dba -P $DBA_PASSWORD exec="vad_install ('ods_briefcase_dav.vad', 0);"

# Create /DAV/ldp folder: http://docs.openlinksw.com/virtuoso/fn_dav_api_add/
oc exec $pod_id -- isql -U dba -P $DBA_PASSWORD exec="select DB.DBA.DAV_COL_CREATE ('/DAV/ldp/','110100100R', 'dav','dav','dav', '${DBA_PASSWORD}');"


# Test the LDP
# echo "<http://subject.org> <http://pred.org> <http://object.org> ." > test-rdf.ttl
# curl -u dav:$DBA_PASSWORD --data-binary @test-rdf.ttl -H "Accept: text/turtle" -H "Content-type: text/turtle" -H "Slug: test-rdf" https://triplestore-bio2kg.apps.dsri2.unimaas.nl/DAV/home/dav
