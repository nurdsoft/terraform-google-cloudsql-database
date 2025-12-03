resource "random_id" "suffix" {
  count       = var.random_instance_name && var.create_database ? 1 : 0
  byte_length = 4
}

# --------------------------
# Private Service Networking
# --------------------------

resource "google_compute_global_address" "private_ip_alloc" {
  count         = var.internal_database_ip ? 1 : 0
  name          = "${var.project_id}-${var.region}-private-ip-range"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = var.private_ip_prefix_length
  address       = var.private_ip_address
  network       = var.ip_configuration.private_network
  project       = var.project_id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  count                   = var.create_service_networking_connection && var.create_database ? 1 : 0
  network                 = var.ip_configuration.private_network
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_alloc[0].name]

  depends_on = [google_compute_global_address.private_ip_alloc]
}

resource "google_sql_database_instance" "sql_database_instance" {
  count               = var.create_database ? 1 : 0
  provider            = google-beta
  project             = var.project_id
  name                = local.master_instance_name
  database_version    = can(regex("\\d", substr(var.database_version, 0, 1))) ? format("POSTGRES_%s", var.database_version) : replace(var.database_version, substr(var.database_version, 0, 8), "POSTGRES")
  region              = var.region
  encryption_key_name = var.encryption_key_name
  deletion_protection = var.deletion_protection
  root_password       = var.root_password

  settings {
    tier                        = var.tier
    edition                     = var.edition
    activation_policy           = var.activation_policy
    availability_type           = var.availability_type
    deletion_protection_enabled = var.deletion_protection_enabled
    connector_enforcement       = local.connector_enforcement

    dynamic "backup_configuration" {
      for_each = [var.backup_configuration]
      content {
        enabled                        = local.backups_enabled
        start_time                     = lookup(backup_configuration.value, "start_time", null)
        location                       = lookup(backup_configuration.value, "location", null)
        point_in_time_recovery_enabled = local.point_in_time_recovery_enabled
        transaction_log_retention_days = lookup(backup_configuration.value, "transaction_log_retention_days", null)

        dynamic "backup_retention_settings" {
          for_each = local.retained_backups != null || local.retention_unit != null ? [var.backup_configuration] : []
          content {
            retained_backups = local.retained_backups
            retention_unit   = local.retention_unit
          }
        }
      }
    }
    dynamic "data_cache_config" {
      for_each = var.edition == "ENTERPRISE_PLUS" && var.data_cache_enabled ? ["cache_enabled"] : []
      content {
        data_cache_enabled = var.data_cache_enabled
      }
    }
    dynamic "deny_maintenance_period" {
      for_each = var.deny_maintenance_period
      content {
        end_date   = lookup(deny_maintenance_period.value, "end_date", null)
        start_date = lookup(deny_maintenance_period.value, "start_date", null)
        time       = lookup(deny_maintenance_period.value, "time", null)
      }
    }
    dynamic "ip_configuration" {
      for_each = [local.ip_configurations[local.ip_configuration_enabled ? "enabled" : "disabled"]]
      content {
        ipv4_enabled                                  = lookup(ip_configuration.value, "ipv4_enabled", null)
        private_network                               = lookup(ip_configuration.value, "private_network", null)
        require_ssl                                   = lookup(ip_configuration.value, "require_ssl", null)
        ssl_mode                                      = lookup(ip_configuration.value, "ssl_mode", null)
        allocated_ip_range                            = lookup(ip_configuration.value, "allocated_ip_range", null)
        enable_private_path_for_google_cloud_services = lookup(ip_configuration.value, "enable_private_path_for_google_cloud_services", false)

        dynamic "authorized_networks" {
          for_each = lookup(ip_configuration.value, "authorized_networks", [])
          content {
            expiration_time = lookup(authorized_networks.value, "expiration_time", null)
            name            = lookup(authorized_networks.value, "name", null)
            value           = lookup(authorized_networks.value, "value", null)
          }
        }

        dynamic "psc_config" {
          for_each = ip_configuration.value.psc_enabled ? ["psc_enabled"] : []
          content {
            psc_enabled               = ip_configuration.value.psc_enabled
            allowed_consumer_projects = ip_configuration.value.psc_allowed_consumer_projects
          }
        }

      }
    }
    dynamic "insights_config" {
      for_each = var.insights_config != null ? [var.insights_config] : []

      content {
        query_insights_enabled  = true
        query_plans_per_minute  = lookup(insights_config.value, "query_plans_per_minute", 5)
        query_string_length     = lookup(insights_config.value, "query_string_length", 1024)
        record_application_tags = lookup(insights_config.value, "record_application_tags", false)
        record_client_address   = lookup(insights_config.value, "record_client_address", false)
      }
    }

    dynamic "password_validation_policy" {
      for_each = var.password_validation_policy_config != null ? [var.password_validation_policy_config] : []

      content {
        enable_password_policy      = true
        min_length                  = lookup(password_validation_policy.value, "min_length", 8)
        complexity                  = lookup(password_validation_policy.value, "complexity", "COMPLEXITY_DEFAULT")
        reuse_interval              = lookup(password_validation_policy.value, "reuse_interval", null)
        disallow_username_substring = lookup(password_validation_policy.value, "disallow_username_substring", true)
        password_change_interval    = lookup(password_validation_policy.value, "password_change_interval", null)
      }
    }

    disk_autoresize       = var.disk_autoresize
    disk_autoresize_limit = var.disk_autoresize_limit
    disk_size             = var.disk_size
    disk_type             = var.disk_type
    pricing_plan          = var.pricing_plan
    dynamic "database_flags" {
      for_each = var.database_flags
      content {
        name  = lookup(database_flags.value, "name", null)
        value = lookup(database_flags.value, "value", null)
      }
    }

    user_labels = var.user_labels

    dynamic "location_preference" {
      for_each = var.zone != null ? ["location_preference"] : []
      content {
        zone                   = var.zone
        secondary_zone         = var.secondary_zone
        follow_gae_application = var.follow_gae_application
      }
    }

    maintenance_window {
      day          = var.maintenance_window_day
      hour         = var.maintenance_window_hour
      update_track = var.maintenance_window_update_track
    }
  }

  lifecycle {
    ignore_changes = [
      settings[0].disk_size
    ]
  }

  timeouts {
    create = var.create_timeout
    update = var.update_timeout
    delete = var.delete_timeout
  }

  depends_on = [
    null_resource.module_depends_on,
    google_service_networking_connection.private_vpc_connection
  ]
}

resource "google_sql_database" "sql_database" {
  count = var.enable_default_db && var.create_database ? 1 : 0
  depends_on = [
    null_resource.module_depends_on,
    google_sql_database_instance.sql_database_instance[0]
  ]
  name            = var.db_name
  project         = var.project_id
  instance        = google_sql_database_instance.sql_database_instance[0].name
  charset         = var.db_charset
  collation       = var.db_collation
  deletion_policy = var.database_deletion_policy
}

resource "google_sql_database" "additional_databases" {
  for_each = var.create_additional_databases && var.create_database ? local.additional_databases : {}
  depends_on = [
    null_resource.module_depends_on,
    google_sql_database_instance.sql_database_instance[0]
  ]
  project         = var.project_id
  name            = each.value.name
  charset         = lookup(each.value, "charset", null)
  collation       = lookup(each.value, "collation", null)
  instance        = google_sql_database_instance.sql_database_instance[0].name
  deletion_policy = var.database_deletion_policy
}

resource "random_password" "user_password" {
  count = var.create_database ? 1 : 0
  keepers = {
    name = google_sql_database_instance.sql_database_instance[0].name
  }
  min_lower   = 1
  min_numeric = 1
  min_upper   = 1
  length      = var.password_validation_policy_config != null ? (var.password_validation_policy_config.min_length != null ? var.password_validation_policy_config.min_length + 4 : 32) : 32
  special     = var.enable_random_password_special ? true : (var.password_validation_policy_config != null ? (var.password_validation_policy_config.complexity == "COMPLEXITY_DEFAULT" ? true : false) : false)
  min_special = var.enable_random_password_special ? 1 : (var.password_validation_policy_config != null ? (var.password_validation_policy_config.complexity == "COMPLEXITY_DEFAULT" ? 1 : 0) : 0)
  depends_on  = [null_resource.module_depends_on, google_sql_database_instance.sql_database_instance]

  lifecycle {
    ignore_changes = [
      min_lower, min_upper, min_numeric, special, min_special, length
    ]
  }
}

resource "random_password" "additional_passwords" {
  for_each = var.create_database ? local.users : {}

  keepers = {
    name = google_sql_database_instance.sql_database_instance[0].name
  }
  min_lower   = 1
  min_numeric = 1
  min_upper   = 1
  length      = var.password_validation_policy_config != null ? (var.password_validation_policy_config.min_length != null ? var.password_validation_policy_config.min_length + 4 : 32) : 32
  special     = var.enable_random_password_special ? true : (var.password_validation_policy_config != null ? (var.password_validation_policy_config.complexity == "COMPLEXITY_DEFAULT" ? true : false) : false)
  min_special = var.enable_random_password_special ? 1 : (var.password_validation_policy_config != null ? (var.password_validation_policy_config.complexity == "COMPLEXITY_DEFAULT" ? 1 : 0) : 0)
  depends_on  = [null_resource.module_depends_on, google_sql_database_instance.sql_database_instance]

  lifecycle {
    ignore_changes = [
      min_lower, min_upper, min_numeric, special, min_special, length
    ]
  }
}

resource "time_sleep" "wait_90_seconds" {
  count           = var.create_database ? 1 : 0
  depends_on      = [google_sql_database_instance.sql_database_instance]
  create_duration = "90s"
}

resource "google_sql_user" "sql_user" {
  count    = var.enable_default_user && var.create_database ? 1 : 0
  name     = var.user_name
  project  = var.project_id
  instance = google_sql_database_instance.sql_database_instance[0].name
  password = var.user_password == "" ? random_password.user_password[0].result : var.user_password
  depends_on = [
    null_resource.module_depends_on,
    google_sql_database_instance.sql_database_instance,
    google_sql_database_instance.sql_database_instance_replica,
  ]
  deletion_policy = var.user_deletion_policy
}

resource "google_sql_user" "additional_users" {
  depends_on = [
    null_resource.module_depends_on,
    google_sql_database_instance.sql_database_instance,
    google_sql_database_instance.sql_database_instance_replica,
  ]
  for_each        = local.users
  project         = var.project_id
  name            = each.value.name
  password        = each.value.random_password ? random_password.additional_passwords[each.value.name].result : each.value.password
  instance        = google_sql_database_instance.sql_database_instance[0].name
  deletion_policy = var.user_deletion_policy
}

resource "google_sql_user" "iam_account" {
  depends_on = [
    time_sleep.wait_90_seconds,
    null_resource.module_depends_on,
  ]

  for_each = local.iam_users

  project = var.project_id
  name = each.value.is_account_sa ? (
    trimsuffix(each.value.email, ".gserviceaccount.com")
    ) : (
    each.value.email
  )
  instance = google_sql_database_instance.sql_database_instance[0].name
  type     = each.value.is_account_sa ? "CLOUD_IAM_SERVICE_ACCOUNT" : "CLOUD_IAM_USER"

  deletion_policy = var.user_deletion_policy
}

resource "null_resource" "module_depends_on" {
  triggers = {
    value = length(var.module_depends_on)
  }
}
