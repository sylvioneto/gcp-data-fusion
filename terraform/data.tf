data "google_project" "project" {}

data "google_compute_network" "datafusion_network" {
  name = "${var.region}-${local.df_name}"
  project = google_data_fusion_instance.df_private.tenant_project_id
}