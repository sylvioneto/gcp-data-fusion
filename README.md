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

3. Clone this repo
```
git clone https://github.com/sylvioneto/gcp-data-fusion.git
cd gcp-data-fusion
```

4. Run the `deploy.sh` script
```
sh deploy.sh
```

## Destroy
Execute Terraform using Cloud Build
```
gcloud builds submit . --config cloudbuild_destroy.yaml
```

## Useful links
- https://www.youtube.com/watch?v=qRwMNK226Pw
- https://cloud.google.com/data-fusion/docs/how-to/create-private-ip
