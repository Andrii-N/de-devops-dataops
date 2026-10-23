terraform {
    required_providers {
        google = {
            source = "hashicorp/google"
            version = "~> 7.0"
        }
    }

    backend "gcs" {
        bucket = "de-devops-dataops-tfstate"
        prefix = "hw-lecture-1"
    }
}

provider "google" {
    project = var.project_id
    region = var.region
    zone = var.zone
}