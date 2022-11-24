locals {
  // Datastream us-central1
  datastream_ips = [
    "34.72.28.29",
    "34.67.234.134",
    "34.67.6.157",
    "34.72.239.218",
    "34.71.242.81"
  ]

  servicenetworking_cidr = "10.200.0.0" #/16
  datafusion_cidr        = "10.201.0.0/22"
}

variable "project_id" {
  description = "GCP Project ID"
  default     = null
}

variable "region" {
  type        = string
  description = "GCP region"
  default     = "us-central1"
}

variable "network_name" {
  type        = string
  description = "VPC name"
  default     = "vpc-data-fusion"
}

variable "db_password" {
  type        = string
  description = "Database default password"
  default     = "supersecret"
}


variable "resource_labels" {
  type        = map(string)
  description = "Resource labels"
  default = {
    terraform = "true"
    purpose   = "test"
    env       = "sandbox"
    repo      = "gcp-data-fusion"
  }
}
