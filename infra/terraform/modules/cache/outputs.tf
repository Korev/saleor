output "host" {
  value     = google_redis_instance.cache.host
  sensitive = true
}

output "port" {
  value = google_redis_instance.cache.port
}
