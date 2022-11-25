resource "google_data_fusion_instance" "df_private" {
  name                          = local.df_instance_name
  description                   = "Data Fusion private instance"
  region                        = var.region
  type                          = "DEVELOPER"
  version                       = "6.7.2"
  enable_stackdriver_logging    = true
  enable_stackdriver_monitoring = true
  labels                        = var.resource_labels
  private_instance              = true

  network_config {
    network       = module.vpc.network_name
    ip_allocation = "${local.datafusion_cidr}/22"
  }

  depends_on = [
    google_compute_global_address.datafusion_range
  ]
}

resource "google_compute_global_address" "datafusion_range" {
  name          = "cdf-${var.region}-${local.df_instance_name}"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  address       = local.datafusion_cidr
  prefix_length = 22
  network       = module.vpc.network_name
}

resource "google_compute_network_peering" "datafusion" {
  name                 = "datafusion-peering"
  network              = module.vpc.network_id
  peer_network         = "projects/${google_data_fusion_instance.df_private.tenant_project_id}/global/networks/${var.region}-${local.df_instance_name}"
  export_custom_routes = true
  import_custom_routes = true
}
