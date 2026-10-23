variable "project_id" {
  description = "Project ID to create resources in."
  type        = string
  default     = "de-devops-dataops"
}

variable "region" {
  description = "Region to place compute resources at."
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "Zone to place compute resource at."
  type        = string
  default     = "us-central1-c"
}

variable "machine_type" {
  description = "Machine type for GCE instance."
  type        = string
  default     = "e2-standard-2"
}

variable "network" {
  description = "Network to create compute resources in."
  type        = string
  default     = "default"
}

variable "subnetwork" {
  description = "Subnet to create compute resources in."
  type        = string
  default     = "default"
}