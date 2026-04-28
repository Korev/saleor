resource "google_artifact_registry_repository" "backend" {
  location      = var.region
  repository_id = "petvamily"
  description   = "Docker images for petvamily services"
  format        = "DOCKER"
}

resource "google_service_account" "saleor_api" {
  account_id   = "saleor-api"
  display_name = "Saleor API Cloud Run"
}

resource "google_service_account" "saleor_worker" {
  account_id   = "saleor-worker"
  display_name = "Saleor Celery Worker Cloud Run"
}

resource "google_service_account" "cloudbuild" {
  account_id   = "saleor-cloudbuild"
  display_name = "Saleor Cloud Build"
}

resource "google_project_iam_member" "api_secret_accessor" {
  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.saleor_api.email}"
}

resource "google_project_iam_member" "worker_secret_accessor" {
  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.saleor_worker.email}"
}

resource "google_storage_bucket_iam_member" "api_storage_admin" {
  bucket = var.media_bucket_name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.saleor_api.email}"
}

resource "google_storage_bucket_iam_member" "worker_storage_admin" {
  bucket = var.media_bucket_name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.saleor_worker.email}"
}

resource "google_project_iam_member" "cloudbuild_run_admin" {
  project = var.project_id
  role    = "roles/run.admin"
  member  = "serviceAccount:${google_service_account.cloudbuild.email}"
}

resource "google_project_iam_member" "cloudbuild_ar_writer" {
  project = var.project_id
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${google_service_account.cloudbuild.email}"
}

resource "google_service_account_iam_member" "cloudbuild_impersonate_api" {
  service_account_id = google_service_account.saleor_api.name
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${google_service_account.cloudbuild.email}"
}

resource "google_service_account_iam_member" "cloudbuild_impersonate_worker" {
  service_account_id = google_service_account.saleor_worker.name
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${google_service_account.cloudbuild.email}"
}

resource "google_project_iam_member" "cloudbuild_logs" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.cloudbuild.email}"
}

# Cloud Build trigger is created manually in GCP Console (Cloud Build → Triggers → Create).
# Terraform cannot create it automatically because it requires a pre-existing GitHub App
# connection in the region, which requires an interactive OAuth flow.
#
# Manual trigger settings:
#   Name:           saleor-backend-deploy
#   Region:         europe-north1
#   Repository:     Korev/saleor (GitHub)
#   Branch filter:  ^main$
#   Included files: saleor/**
#   Config file:    saleor/cloudbuild.yaml
#   Service account: saleor-cloudbuild@<project>.iam.gserviceaccount.com
