# gcp-data-fusion
This project shows how to connect from Data Fusion private instances to Cloud SQL private instances

Resources created
- VPC
- Compute Engine VM
- Cloud SQL for MySQL
- Cloud Data Fusion

## Deploy

1. Click on Open in Google Cloud Shell button below.
<a href="https://ssh.cloud.google.com/cloudshell/editor?shellonly=true&cloudshell_git_repo=https%3A%2F%2Fgithub.com%2Fsylvioneto%2Fgcp-data-fusion" target="_new">
    <img alt="Open in Cloud Shell" src="https://gstatic.com/cloudssh/images/open-btn.svg">
</a>

2. Run the `deploy.bash` script
```
bash deploy.bash
```

## Destroy
Execute Terraform using Cloud Build
```
bash destroy.bash
```

## Useful links
- https://www.youtube.com/watch?v=qRwMNK226Pw
- https://cloud.google.com/data-fusion/docs/how-to/create-private-ip
