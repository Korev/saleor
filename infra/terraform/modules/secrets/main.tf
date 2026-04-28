locals {
  secret_names = [
    "saleor-database-url",
    "saleor-redis-url",
    "saleor-secret-key",
    "saleor-allowed-hosts",
    "saleor-default-from-email",
    "saleor-app-token",
    "saleor-storefront-url",
    "saleor-gcs-media-bucket",
  ]
}

resource "google_secret_manager_secret" "secrets" {
  for_each  = toset(local.secret_names)
  secret_id = each.key

  replication {
    auto {}
  }
}
