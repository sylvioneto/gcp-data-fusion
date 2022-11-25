locals {
  servicenetworking_cidr = "10.200.0.0"  #/16
  datafusion_cidr        = "10.124.40.0" #/22

  df_instance_name  = "df-private"
  sql_instance_name = "mysql-${random_id.db_name_suffix.hex}"
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
