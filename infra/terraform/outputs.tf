output "vpc_connector_name" {
  value = module.networking.vpc_connector_name
}

output "db_private_ip" {
  value     = module.database.private_ip
  sensitive = true
}

output "redis_host" {
  value     = module.cache.host
  sensitive = true
}

output "redis_port" {
  value = module.cache.port
}

output "media_bucket_name" {
  value = module.storage.bucket_name
}

output "media_bucket_url" {
  value = module.storage.bucket_url
}

output "api_service_account_email" {
  value = module.iam.api_service_account_email
}

output "worker_service_account_email" {
  value = module.iam.worker_service_account_email
}

output "artifact_registry_url" {
  value = module.iam.artifact_registry_url
}
