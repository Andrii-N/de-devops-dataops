variable "project_id" {
  description = "Project ID to create the state bucket in."
  type        = string
  default     = "de-devops-dataops"
}

variable "region" {
  description = "Location of the state bucket."
  type        = string
  default     = "us-central1"
}

variable "state_versions_to_keep" {
  description = "How many old (noncurrent) state versions to keep before deleting them."
  type        = number
  default     = 5
}
