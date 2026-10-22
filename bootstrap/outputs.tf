output "state_bucket_name" {
  description = "Paste this into the backend \"gcs\" block of the main config."
  value       = google_storage_bucket.tfstate.name
}

output "state_bucket_url" {
  value = google_storage_bucket.tfstate.url
}
