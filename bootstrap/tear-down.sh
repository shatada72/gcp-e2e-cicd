# Cleanup script to delete the three clusters created by the gke-cluster-init.sh script
# ACTION REQUIRED! Change "project-id-here" value to the project you'll be using
export PROJECT_ID=$(gcloud config list --format 'value(core.project)')
# sets the current project for gcloud
gcloud config set project $PROJECT_ID
# Test cluster
echo "Deleting testcluster..."
gcloud container clusters delete testcluster --zone europe-west1-b --async --quiet
# Staging cluster
echo "Deleting stagingcluster..."
gcloud container clusters delete stagingcluster --zone europe-west1-b --async --quiet
# Prod cluster
echo "Deleting prodcluster..."
gcloud container clusters delete prodcluster --zone europe-west1-b --async --quiet

# Delete artifact registry
gcloud artifacts repositories delete repo-techub-python --location=europe-west1  --quiet

# Delete deploy pipeline
gcloud deploy delete \
	--file clouddeploy.yaml \
	--region=europe-west1 \
	--project=$PROJECT_ID \
--quiet --force

# Delete Cloud Build Trigger
gcloud beta builds triggers delete Cloud-Deploy-Demo --region europe-west1 --quiet
