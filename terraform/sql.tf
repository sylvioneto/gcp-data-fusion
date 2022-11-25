resource "random_id" "db_name_suffix" {
  byte_length = 4
}

resource "google_sql_database_instance" "instance" {
  name                = local.sql_instance_name
  region              = var.region
  database_version    = "MYSQL_8_0"
  deletion_protection = false # not recommended for PROD

  settings {
    tier        = "db-custom-1-3840"
    user_labels = var.resource_labels

    ip_configuration {
      private_network = module.vpc.network_self_link
      ipv4_enabled    = false
    }
  }

  depends_on = [google_service_networking_connection.private_service_connection]
}

resource "google_sql_user" "datafusion" {
  instance = google_sql_database_instance.instance.id
  name     = "datafusion"
  password = var.db_password
}
