resource "google_compute_instance" "cloudsql_proxy" {
  name         = "cloudsql-proxy"
  machine_type = "e2-small"
  zone         = "${var.region}-b"

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
    network = module.vpc.network_name
    subnetwork = "subnet-${var.region}"
  }

  metadata = {
    foo = "bar"
  }

  metadata_startup_script = "docker run -d -p 0.0.0.0:3306:3306 gcr.io/cloudsql-docker/gce-proxy:latest /cloud_sql_proxy -instances=${google_sql_database_instance.instance.connection_name}=tcp:0.0.0.0:3306"

  service_account {
    email  = google_service_account.proxy_sa.email
    scopes = ["cloud-platform"]
  }
}