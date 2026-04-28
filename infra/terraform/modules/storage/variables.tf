variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "storefront_origins" {
  type        = list(string)
  description = "Allowed CORS origins for the media bucket"
}
