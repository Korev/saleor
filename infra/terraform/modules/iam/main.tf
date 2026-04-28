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

resource "google_project_iam_member" "cloudbuild_sa_user" {
  project = var.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.cloudbuild.email}"
}

resource "google_project_iam_member" "cloudbuild_logs" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.cloudbuild.email}"
}

resource "google_cloudbuild_trigger" "saleor_backend" {
  name            = "saleor-backend-deploy"
  location        = var.region
  service_account = google_service_account.cloudbuild.id

  github {
    owner = var.github_owner
    name  = var.github_repo
    push {
      branch = "^main$"
    }
  }

  included_files = ["saleor/**"]
  filename       = "saleor/cloudbuild.yaml"
}
