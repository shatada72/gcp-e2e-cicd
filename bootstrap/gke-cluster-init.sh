# Creates 3 GKE autopilot clusters
# ACTION REQUIRED! Change "project-id-here" value to the project you'll be using
export PROJECT_ID=$(gcloud config list --format 'value(core.project)')

export CLUSTER_ZONE=europe-west1-b
export VPC=default
export SUBNET=default

# Test cluster
echo "creating testcluster..."
gcloud container clusters create testcluster \
	--project=techub-demos-host  \
	--zone=${CLUSTER_ZONE} \
	--network=${VPC} \
	--subnetwork=${SUBNET} \
	--async 

# Staging cluster
echo "creating stagingcluster..."
gcloud container clusters create stagingcluster \
	--project=${PROJECT_ID} \
	--zone=${CLUSTER_ZONE} \
	--network=${VPC} \
	--subnetwork=${SUBNET} \
	--async 

# Prod cluster
echo "creating prodcluster..."
gcloud container clusters create prodcluster \
	--project=${PROJECT_ID} \
	--zone=${CLUSTER_ZONE} \
	--network=${VPC} \
	--subnetwork=${SUBNET} \
	--async 

echo "Creating clusters! Check the UI for progress"
