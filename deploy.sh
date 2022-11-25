#!/bin/sh
set -e

if [ -z "$GOOGLE_CLOUD_PROJECT" ]
then
   echo "Project not set! Please set project with gcloud config set project <project-id>"
   exit 1
else
   echo "Project $GOOGLE_CLOUD_PROJECT"
fi

BUCKET_NAME=gs://$GOOGLE_CLOUD_PROJECT-tf-state
if gsutil ls $BUCKET_NAME; then
    echo "Terraform bucket already created!"
else
    echo "Creating Terraform state bucket..."
    gsutil mb $BUCKET_NAME
fi

echo "Enabling required APIs..."
gcloud services enable compute.googleapis.com \
    container.googleapis.com \
    datafusion.googleapis.com \
    dataproc.googleapis.com \
    dns.googleapis.com \
    bigquery.googleapis.com \
    storage.googleapis.com \
    sqladmin.googleapis.com

echo "Granting IAM roles to Cloud Build's Service Account..."
PROJECT_NUMBER=$(gcloud projects describe $GOOGLE_CLOUD_PROJECT --format='value(projectNumber)')
gcloud projects add-iam-policy-binding $GOOGLE_CLOUD_PROJECT --member=serviceAccount:$PROJECT_NUMBER@cloudbuild.gserviceaccount.com --role=roles/editor
gcloud projects add-iam-policy-binding $GOOGLE_CLOUD_PROJECT --member=serviceAccount:$PROJECT_NUMBER@cloudbuild.gserviceaccount.com --role=roles/iam.securityAdmin

echo "Triggering Cloud Build job..."
gcloud builds submit . --config cloudbuild.yaml
