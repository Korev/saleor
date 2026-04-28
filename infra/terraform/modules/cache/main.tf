resource "google_redis_instance" "cache" {
  name               = "petvamily-redis"
  tier               = "BASIC"
  memory_size_gb     = 1
  region             = var.region
  authorized_network = var.vpc_id
  connect_mode       = "DIRECT_PEERING"
  redis_version      = "REDIS_7_0"
  display_name       = "Petvamily Redis"
}
