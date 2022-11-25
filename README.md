# gcp-data-fusion
This project shows how to connect from Data Fusion private instances to Cloud SQL private instances

Resources created
- VPC
- Compute Engine VM
- Cloud SQL for MySQL
- Cloud Data Fusion

## Deploy

1. Create a new project and select it
2. Open Cloud Shell and ensure the env var below is set, otherwise set it with `gcloud config set project` command
```
echo $GOOGLE_CLOUD_PROJECT
```

3. Create a bucket to store your project's Terraform state
```
gsutil mb gs://$GOOGLE_CLOUD_PROJECT-tf-state
```

4. Enable the necessary APIs
```
gcloud services enable compute.googleapis.com \
    container.googleapis.com \
    datafusion.googleapis.com\
    dataproc.googleapis.com\
    bigquery.googleapis.com \
    storage.googleapis.com \
    sqladmin.googleapis.com 
```

5. Give permissions to Cloud Build for creating the resources
```
PROJECT_NUMBER=$(gcloud projects describe $GOOGLE_CLOUD_PROJECT --format='value(projectNumber)')
gcloud projects add-iam-policy-binding $GOOGLE_CLOUD_PROJECT --member=serviceAccount:$PROJECT_NUMBER@cloudbuild.gserviceaccount.com --role=roles/editor
gcloud projects add-iam-policy-binding $GOOGLE_CLOUD_PROJECT --member=serviceAccount:$PROJECT_NUMBER@cloudbuild.gserviceaccount.com --role=roles/iam.securityAdmin
```

6. Clone this repo
```
git clone https://github.com/sylvioneto/gcp-data-fusion.git
cd gcp-cloud-composer
```

7. Execute Terraform using Cloud Build
```
gcloud builds submit . --config cloudbuild.yaml
```

8. Go to [Cloud Composer](https://console.cloud.google.com/composer) and check out the dags


## Destroy
Execute Terraform using Cloud Build
```
gcloud builds submit . --config cloudbuild_destroy.yaml
```

## Useful links
- https://www.youtube.com/watch?v=qRwMNK226Pw
- https://cloud.google.com/data-fusion/docs/how-to/create-private-ip
