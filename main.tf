resource "google_storage_bucket" "gcs-hw-lecture-1" {
  name          = "${var.project_id}-gcs-hw-lecture-1"
  location      = var.region
  force_destroy = true
}

resource "google_bigquery_dataset" "bq_dataset_hw_lecture_1" {
  dataset_id = "bq_dataset_hw_lecture_1"
  location   = var.region
}

resource "google_compute_instance" "gce-vm-instance-hw-lecture-1" {
  name         = "hw-lecture-1"
  zone         = var.zone
  machine_type = var.machine_type
  boot_disk {
    initialize_params {
      image = "centos-stream-9"
    }
  }
  network_interface {
    network    = var.network
    subnetwork = var.subnetwork
    access_config {
    }
  }
}