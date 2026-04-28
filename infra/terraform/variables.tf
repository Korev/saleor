variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region for all resources"
  type        = string
  default     = "europe-north1"
}

variable "db_password" {
  description = "Cloud SQL saleor user password"
  type        = string
  sensitive   = true
}

variable "storefront_origins" {
  description = "Allowed CORS origins for the GCS media bucket (storefront URLs)"
  type        = list(string)
}

variable "github_owner" {
  description = "GitHub user or org that owns the repo"
  type        = string
}

variable "github_repo" {
  description = "GitHub repository name (without owner prefix)"
  type        = string
}
