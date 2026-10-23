resource "google_storage_bucket" "gcs-hw-lecture-1" {
  name          = "${var.project_id}-gcs-hw-lecture-1"
  location      = var.region
  force_destroy = true
}

resource "google_bigquery_dataset" "bq_dataset_hw_lecture_1" {
  dataset_id = "bq_dataset_hw_lecture_1"
  location   = var.region
}