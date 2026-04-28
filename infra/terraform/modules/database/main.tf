resource "google_sql_database_instance" "postgres" {
  name             = "petvamily-postgres"
  database_version = "POSTGRES_15"
  region           = var.region

  deletion_protection = true

  settings {
    tier = "db-f1-micro"

    backup_configuration {
      enabled                        = true
      point_in_time_recovery_enabled = true
      start_time                     = "03:00"
    }

    ip_configuration {
      ipv4_enabled                                  = false
      private_network                               = var.vpc_id
      enable_private_path_for_google_cloud_services = true
    }
  }
}

resource "google_sql_database" "saleor" {
  name     = "saleor"
  instance = google_sql_database_instance.postgres.name
}

resource "google_sql_user" "saleor" {
  name     = "saleor"
  instance = google_sql_database_instance.postgres.name
  password = var.db_password
}
