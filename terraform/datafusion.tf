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

  version = "6.3.0"

  # Mark for testing to avoid service networking connection usage that is not cleaned up
  options = {
    prober_test_run = "true"
  }
}
