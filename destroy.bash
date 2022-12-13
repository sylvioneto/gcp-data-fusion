#!/bin/bash
set -e

if [ -z "$GOOGLE_CLOUD_PROJECT" ]
then
   echo Project not set!
   echo What project do you want to deploy the solution to?
   read varprojectid
   gcloud config set project $varprojectid
   export GOOGLE_CLOUD_PROJECT=$varprojectid
fi

echo Deploying the solution onto project $GOOGLE_CLOUD_PROJECT

echo Triggering Cloud Build job...
gcloud builds submit . --config cloudbuild_destroy.yaml

echo Solution destroyed successfully!
