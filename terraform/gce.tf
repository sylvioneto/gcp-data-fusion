resource "google_compute_instance" "cloudsql_proxy" {
  name         = "cloudsql-proxy-${local.sql_instance_name}"
  machine_type = "e2-small"
  zone         = data.google_compute_zones.available.names[0]

  tags = ["allow-ssh"]

  boot_disk {
    initialize_params {
      image = "cos-cloud/cos-101-lts"
      labels = {
        vm_name = "cloudsql-proxy"
      }
    }
  }

  network_interface {
    network    = module.vpc.network_name
    subnetwork = "subnet-${var.region}"
  }

  metadata_startup_script = <<EOF
  curl -sSO https://dl.google.com/cloudagents/add-google-cloud-ops-agent-repo.sh
  sudo bash add-google-cloud-ops-agent-repo.sh --also-install

  docker run -d -p 0.0.0.0:3306:3306 gcr.io/cloudsql-docker/gce-proxy:latest /cloud_sql_proxy -instances=${google_sql_database_instance.instance.connection_name}=tcp:0.0.0.0:3306
  EOF

  service_account {
    email  = google_service_account.proxy_sa.email
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_instance" "mysql_client" {
  name         = "mysql-client"
  machine_type = "e2-small"
  zone         = data.google_compute_zones.available.names[0]

  tags = ["allow-ssh"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }

  network_interface {
    network    = module.vpc.network_name
    subnetwork = "subnet-${var.region}"
  }

  metadata_startup_script = <<EOF
  curl -sSO https://dl.google.com/cloudagents/add-google-cloud-ops-agent-repo.sh
  sudo bash add-google-cloud-ops-agent-repo.sh --also-install

  sudo apt update
  sudo apt upgrade -y
  sudo apt install mysql-client -y

  git clone https://github.com/datacharmer/test_db.git
  cd test_db

  MYSQL_IP=$(gcloud sql instances describe ${local.sql_instance_name} --format='get(ipAddresses.ipAddress)' --project=${var.project_id})
  mysql -h$MYSQL_IP -udatafusion -p${var.db_password} -Demp < employees.sql
  EOF

  service_account {
    email  = google_service_account.proxy_sa.email
    scopes = ["cloud-platform"]
  }
}
