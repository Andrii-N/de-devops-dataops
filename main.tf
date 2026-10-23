resource "google_storage_bucket" "gcs-hw-lecture-1" {
  name          = "${var.project_id}-gcs-hw-lecture-1"
  location      = var.region
  force_destroy = true
}