terraform {
  required_version = ">= 1.8"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
  backend "gcs" {
    bucket = "vetfamily-494417-tfstate"
    prefix = "terraform/state"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_project_service" "apis" {
  for_each = toset([
    "compute.googleapis.com",
    "sqladmin.googleapis.com",
    "redis.googleapis.com",
    "storage.googleapis.com",
    "secretmanager.googleapis.com",
    "run.googleapis.com",
    "cloudbuild.googleapis.com",
    "vpcaccess.googleapis.com",
    "servicenetworking.googleapis.com",
    "artifactregistry.googleapis.com",
  ])
  service            = each.key
  disable_on_destroy = false
}

module "networking" {
  source     = "./modules/networking"
  region     = var.region
  depends_on = [google_project_service.apis]
}

module "database" {
  source      = "./modules/database"
  region      = var.region
  vpc_id      = module.networking.vpc_id
  db_password = var.db_password
  depends_on  = [module.networking]
}

module "cache" {
  source     = "./modules/cache"
  region     = var.region
  vpc_id     = module.networking.vpc_id
  depends_on = [google_project_service.apis]
}

module "storage" {
  source             = "./modules/storage"
  project_id         = var.project_id
  region             = var.region
  storefront_origins = var.storefront_origins
}

module "iam" {
  source            = "./modules/iam"
  project_id        = var.project_id
  region            = var.region
  media_bucket_name = module.storage.bucket_name
  github_owner      = var.github_owner
  github_repo       = var.github_repo
  depends_on        = [google_project_service.apis]
}

module "secrets" {
  source     = "./modules/secrets"
  depends_on = [google_project_service.apis]
}
