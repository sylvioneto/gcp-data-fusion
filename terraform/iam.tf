resource "google_service_account" "proxy_sa" {
  account_id   = "cloudsql-proxy"
  display_name = "Service Account for Cloud SQL proxy vms"
}

resource "google_project_iam_member" "sql_client" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.proxy_sa.email}"
}
