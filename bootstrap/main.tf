# Bootstrap: creates the GCS bucket that stores the remote state of the main config.
# This folder intentionally has NO backend block, so its own state stays local
# (bootstrap/terraform.tfstate). Run it once, before `tofu init` in the repo root.

terraform {
  required_version = ">= 1.6"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_storage_bucket" "tfstate" {
  # Bucket names are global across all of GCP, so prefix with the project ID.
  name     = "${var.project_id}-tfstate"
  location = var.region

  # Never let `destroy` silently wipe state files that live in the bucket.
  force_destroy = false

  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"

  # Every state write creates a new object version, so a corrupted state can be rolled back.
  versioning {
    enabled = true
  }

  # Keep only the last few old versions so the bucket doesn't grow forever.
  lifecycle_rule {
    condition {
      num_newer_versions = var.state_versions_to_keep
      with_state         = "ARCHIVED"
    }
    action {
      type = "Delete"
    }
  }

  labels = {
    purpose = "terraform-state"
  }

  # Guards against an accidental `tofu destroy` here.
  # Remove this block when you really want to delete the bucket (homework cleanup).
  lifecycle {
    prevent_destroy = true
  }
}
