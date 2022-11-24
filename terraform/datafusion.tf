resource "google_data_fusion_instance" "df_private" {
  name                          = local.df_name
  description                   = "My Data Fusion private instance"
  region                        = var.region
  type                          = "DEVELOPER"
  enable_stackdriver_logging    = true
  enable_stackdriver_monitoring = true

  labels           = var.resource_labels
  private_instance = true

  network_config {
    network       = module.vpc.network_name
    ip_allocation = local.datafusion_cidr
  }

  version = "6.7.2"

  #   # Mark for testing to avoid service networking connection usage that is not cleaned up
  #   options = {
  #     prober_test_run = "true"
  #   }
}


## Peering ##
resource "google_compute_network_peering" "datafusion" {
  name                 = "datafusion-peering"
  network              = module.vpc.network_id
  peer_network         = "projects/${google_data_fusion_instance.df_private.tenant_project_id}/global/networks/${var.region}-${local.df_name}"
  export_custom_routes = true
  import_custom_routes = true
}
