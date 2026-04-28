output "private_ip" {
  value     = google_sql_database_instance.postgres.private_ip_address
  sensitive = true
}

output "instance_name" {
  value = google_sql_database_instance.postgres.name
}

output "database_name" {
  value = google_sql_database.saleor.name
}

output "user_name" {
  value = google_sql_user.saleor.name
}
