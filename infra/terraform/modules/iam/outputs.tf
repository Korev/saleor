output "api_service_account_email" {
  value = google_service_account.saleor_api.email
}

output "worker_service_account_email" {
  value = google_service_account.saleor_worker.email
}

output "artifact_registry_url" {
  value = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.backend.repository_id}"
}
