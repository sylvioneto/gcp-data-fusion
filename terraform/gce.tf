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

  metadata_startup_script = "docker run -d -p 0.0.0.0:3306:3306 gcr.io/cloudsql-docker/gce-proxy:latest /cloud_sql_proxy -instances=${google_sql_database_instance.instance.connection_name}=tcp:0.0.0.0:3306"

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
  sudo apt update
  sudo apt upgrade -y
  sudo apt install mysql-client -y
  EOF

  service_account {
    email  = google_service_account.proxy_sa.email
    scopes = ["cloud-platform"]
  }
}
