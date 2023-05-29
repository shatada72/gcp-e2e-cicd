# Initilize set project ID variable and run various initializations
# ACTION REQUIRED! Change "project-id-here" value to the project you'll be using
export PROJECT_ID=$(gcloud config list --format 'value(core.project)')

# sets the current project for gcloud
gcloud config set project $PROJECT_ID

# Enables various APIs you'll need
gcloud services enable \
	container.googleapis.com \
	cloudbuild.googleapis.com \
	artifactregistry.googleapis.com \
	clouddeploy.googleapis.com \
	cloudresourcemanager.googleapis.com

# creates the Artifact Registry repo
gcloud artifacts repositories create repo-techub-python \
	--location=europe-west1 \
	--repository-format=docker

# creates the Google Cloud Deploy pipeline
gcloud deploy apply \
	--file clouddeploy.yaml \
	--region=europe-west1 \
	--project=$PROJECT_ID

echo "init done. To create clusters, run: ./gke-cluster-init.sh"
