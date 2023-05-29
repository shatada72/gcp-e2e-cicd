# Google Cloud CI/CD End-to-End + Sonarqube Quality Gate Demo
This repo demonstrates Kubernetes development and deployment with Skaffold and Google Cloud devops tools Google Cloud Build, Cloud Deploy, and Artifact Registry. The example is a simple Hello World Python app and uses Kustomize overlays for manifest generation. 

## Repository structure
The main files/folders in this repository are:

- app/Dockerfile specifies how the application is built and packaged
- bootstrap/init.sh contains initial configurations
- bootstrap/gke-cluster-init.sh contains commands to create the k8s clusters where the application will run (targets of cloud deploy)
- k8s contains base and overlays files for Kustomize
- cloudbuid.yaml contains the pipeline build steps
- clouddeploy.yaml is used to create the pipeline and the deploy targets

## Create a repo
This demo relies on you making git check-ins/pushes to simulate a development workflow. Fork this repo, or otherwise copy it into your own Github repo.

## Bootstrap Google Cloud demo
Bootstrap scripts are in the `bootstrap` folder.

The `init.sh` script is provided to bootstrap much of the configuration setup. You'll still need to do some steps manually after this script runs though.

1. Clone this repo and commit it to your own git repo.
2. Replace project-id-here with your Google Cloud project-id on line 3.
3. run `. ./bootstrap/init.sh`
4. Verify that the Google Cloud Deploy pipeline was created in [Google Cloud Deploy UI](https://console.cloud.google.com/deploy/delivery-pipelines)
5. Setup a Cloud Build trigger for your repo
  * Navigate to [Cloud Build triggers page](https://console.cloud.google.com/cloud-build/triggers)
  * Follow the [docs](https://cloud.google.com/build/docs/automating-builds/build-repos-from-github) and create a Github App connected repo and trigger.

## Create GKE clusters
You'll need GKE clusters to deploy out to as part of the demo. This repo refers to three clusters:
* testcluster
* stagingcluster
* productcluster

If you have/want different cluster names update cluster definitions in the gke-cluster-init.sh bash script and in clouddeploy.yaml

To create the clusters, edit `bootstrap/gke-cluster-init.sh`:
1. Replace `project-id-here` with your project-id on line 3.
2. Run `. .bootstrap/gke-cluster-init.sh`

These clusters are being created with Autopilot mode, check the [docs] (https://cloud.google.com/kubernetes-engine/docs/concepts/autopilot-overview) for reference

## IAM and service account setup
You must give Cloud Build explicit permission to trigger a Cloud Deploy release.
1. Read the [docs](https://cloud.google.com/deploy/docs/integrating)
2. Navigate to IAM and locate your Cloud Build service account
3. Add these two roles
  * Cloud Deploy Releaser
  * Service Account User

## Sonarqube  
This demo is using the Sonarqube community cloud builder (https://github.com/GoogleCloudPlatform/cloud-builders-community/tree/master/sonarqube)

Follow the builder documentation to setup the authentication and sonarqube docs to setup the Sonarqube project

This demo is using sonarcloud.oi (Sonarqube cloud/SaaS), in order to use it, it is free for public/open source repositories.

## Secret Manager
This demo is using secrets from Secret Manager to store and retrieve some sensitive information, like Sonarqube user and token, to setup and use Secret Manager with Cloud Build, follow these steps: https://cloud.google.com/build/docs/securing-builds/use-secrets

## Demo
The demo is very simple at this stage, some steps that can be followed to show the e2e pipeline:
1. User commits a change the main branch of the repo
2. Cloud Build is automatically triggered, which:
  * builds the image
  * runs unit tests
  * checks the code with Sonarqube (set -Dsonar.qualitygate.wait true if you want the build to fail if the code doesn't meet the quality requirements)
  * pushes the image to artifact registry
  * creates a Cloud Deploy release in the pipeline
3. User then navigates to Cloud Deploy UI and shows promotion events:
  * test cluster to staging clusters
  * staging cluster to product cluster, with approval gate
  * show the application GKE > Services > Click on the external IP 


## Tear down
To remove the three running GKE clusters, edit `bootstrap/gke-cluster-delete.sh`:
1. Replace `project-id-here` with your project-id on line 3.
2. Run `. .bootstrap/gke-cluster-delete.sh`

# Building, Deploying & Running manually
While there are several ways to build and run the app in this repo, the intention is to demonstrate Skaffold and Kustomize in local development scenarios ("dev"), as well as deployments to two additional environments: "staging" and "prod". 

## Local dev
To run this app locally, start minikube or some other local k8s framework and from the root of the repo run:

`skaffold dev`

This profile uses the "dev" customer overlay.

Once running, you can make file changes and observe the rebuilding of the container and redeployment.

## Staging 
To deploy to staging, set your kube context to the proper cluster and run:

`skaffold run --profile staging`

## Prod
To deploy to prod, set your kube context to the proper cluster and run:

`skaffold run --profile prod`

## Try it in Cloud Shell
Google Cloud Shell provides a free environment in which to play with these files:

[![Open in cloud shell](https://gstatic.com/cloudssh/images/open-btn.svg)](https://console.cloud.google.com/cloudshell/open?git_repo=https://github.com/wrg02/cicd-demo&page=editor&open_in_editor=skaffold.yaml)

# About the Sample app - Hello World Python

Simple Python hello-world web app (https://github.com/datawire/hello-world-python)
