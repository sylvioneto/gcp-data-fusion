resource "random_id" "db_name_suffix" {
  byte_length = 4
}

resource "google_sql_database_instance" "instance" {
  name                = "private-mysql-${random_id.db_name_suffix.hex}"
  region              = var.region
  database_version    = "MYSQL_5_7"
  deletion_protection = false # not recommended for PROD

  settings {
    tier        = "db-custom-1-3840"
    user_labels = var.resource_labels

    ip_configuration {
      private_network = module.vpc.network_self_link

      dynamic "authorized_networks" {
        for_each = local.datastream_ips
        iterator = datastream_ips

        content {
          name  = "datastream-${datastream_ips.key}"
          value = datastream_ips.value
        }
      }
    }
  }

  depends_on = [google_service_networking_connection.private_service_connection]
}

resource "google_sql_user" "datafusion" {
  instance = google_sql_database_instance.instance.id
  name     = "datafusion"
  password = var.db_password
}
