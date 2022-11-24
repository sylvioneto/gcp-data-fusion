module "vpc" {
  source       = "terraform-google-modules/network/google"
  version      = "~> 5.0"
  project_id   = var.project_id
  network_name = var.network_name
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name           = "subnet-${var.region}"
      subnet_ip             = "10.0.0.0/24"
      subnet_region         = var.region
      subnet_private_access = true
    },
  ]
}

resource "google_compute_global_address" "service_range" {
  name          = "servicenetworking-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  address       = local.servicenetworking_cidr
  prefix_length = 16
  network       = module.vpc.network_name
}

resource "google_service_networking_connection" "private_service_connection" {
  network                 = module.vpc.network_id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.service_range.name]
}

## Nat ## 
resource "google_compute_router" "nat_router" {
  name    = "${module.vpc.network_name}-nat-router"
  network = module.vpc.network_self_link
  region  = var.region
}

resource "google_compute_router_nat" "nat_gateway" {
  name                               = "${module.vpc.network_name}-nat-gw"
  router                             = google_compute_router.nat_router.name
  region                             = google_compute_router.nat_router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

## Firewall ## 
resource "google_compute_firewall" "allow_df_private" {
  name    = "allow-private-data-fusion"
  network = module.vpc.network_name

  allow {
    protocol = "tcp"
    ports    = ["22", "3306", "5432", "1433"]
  }

  source_ranges = [local.datafusion_cidr]
}


## Peering ##
resource "google_compute_network_peering" "datafusion" {
  name                 = "datafusion-peering"
  network              = module.vpc.network_id
  peer_network         = data.google_compute_network.datafusion_network.id
  export_custom_routes = true
  import_custom_routes = true
}

