resource "google_storage_bucket" "df_output" {
  name                        = "${var.project_id}-df-output"
  des
  location                    = var.region
  uniform_bucket_level_access = true
  force_destroy               = true
}
