terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = "data-project"
}

locals {
  # Merge default and custom labels
  labels = merge(var.default_labels, {
    environment = var.environment
  })
  # Default database that must always exist
  default_database = [{
    name      = "${var.default_labels["customer"]}-${var.environment}"
    charset   = "UTF8"
    collation = "en_US.UTF8"
  }]
}

module "database" {
  source  = "nurdsoft/cloudsql-database/google"
  version = "0.1.0"
  project_id          = var.project_id
  labels              = merge(local.labels, { component = "database" })
  region              = var.region
  database_version    = var.db_version
  zone                = var.db_zone
  edition             = var.db_edition
  tier                = var.db_tier
  user_name           = var.db_user_name
  user_password       = var.db_user_password
  deletion_protection = var.db_deletion_protection
  ip_configuration = {
    ipv4_enabled = true
  }
  enable_default_db           = false
  create_additional_databases = true
  additional_databases        = var.additional_dbs
}
