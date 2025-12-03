## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_google"></a> [google](#requirement\_google) | 5.16.0 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | 5.16.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | 3.2.2 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 5.16.0 |
| <a name="provider_google-beta"></a> [google-beta](#provider\_google-beta) | 5.16.0 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.2 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.0 |
| <a name="provider_time"></a> [time](#provider\_time) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google-beta_google_sql_database_instance.sql_database_instance](https://registry.terraform.io/providers/hashicorp/google-beta/5.16.0/docs/resources/google_sql_database_instance) | resource |
| [google-beta_google_sql_database_instance.sql_database_instance_replica](https://registry.terraform.io/providers/hashicorp/google-beta/5.16.0/docs/resources/google_sql_database_instance) | resource |
| [google_compute_global_address.private_ip_alloc](https://registry.terraform.io/providers/hashicorp/google/5.16.0/docs/resources/compute_global_address) | resource |
| [google_service_networking_connection.private_vpc_connection](https://registry.terraform.io/providers/hashicorp/google/5.16.0/docs/resources/service_networking_connection) | resource |
| [google_sql_database.additional_databases](https://registry.terraform.io/providers/hashicorp/google/5.16.0/docs/resources/sql_database) | resource |
| [google_sql_database.sql_database](https://registry.terraform.io/providers/hashicorp/google/5.16.0/docs/resources/sql_database) | resource |
| [google_sql_user.additional_users](https://registry.terraform.io/providers/hashicorp/google/5.16.0/docs/resources/sql_user) | resource |
| [google_sql_user.iam_account](https://registry.terraform.io/providers/hashicorp/google/5.16.0/docs/resources/sql_user) | resource |
| [google_sql_user.sql_user](https://registry.terraform.io/providers/hashicorp/google/5.16.0/docs/resources/sql_user) | resource |
| [null_resource.module_depends_on](https://registry.terraform.io/providers/hashicorp/null/3.2.2/docs/resources/resource) | resource |
| [random_id.suffix](https://registry.terraform.io/providers/hashicorp/random/3.6.0/docs/resources/id) | resource |
| [random_password.additional_passwords](https://registry.terraform.io/providers/hashicorp/random/3.6.0/docs/resources/password) | resource |
| [random_password.user_password](https://registry.terraform.io/providers/hashicorp/random/3.6.0/docs/resources/password) | resource |
| [time_sleep.wait_90_seconds](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [google_compute_zones.available](https://registry.terraform.io/providers/hashicorp/google/5.16.0/docs/data-sources/compute_zones) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_activation_policy"></a> [activation\_policy](#input\_activation\_policy) | The activation policy for the master instance.Can be either `ALWAYS`, `NEVER` or `ON_DEMAND`. | `string` | `"ALWAYS"` | no |
| <a name="input_additional_databases"></a> [additional\_databases](#input\_additional\_databases) | A list of databases to be created in your cluster | <pre>list(object({<br/>    name      = string<br/>    charset   = string<br/>    collation = string<br/>  }))</pre> | `[]` | no |
| <a name="input_additional_users"></a> [additional\_users](#input\_additional\_users) | A list of users to be created in your cluster. A random password would be set for the user if the `random_password` variable is set. | <pre>list(object({<br/>    name            = string<br/>    password        = string<br/>    random_password = bool<br/>  }))</pre> | `[]` | no |
| <a name="input_availability_type"></a> [availability\_type](#input\_availability\_type) | The availability type for the master instance.This is only used to set up high availability for the PostgreSQL instance. Can be either `ZONAL` or `REGIONAL`. | `string` | `"ZONAL"` | no |
| <a name="input_backup_configuration"></a> [backup\_configuration](#input\_backup\_configuration) | The backup\_configuration settings subblock for the database setings | <pre>object({<br/>    enabled                        = optional(bool, false)<br/>    start_time                     = optional(string)<br/>    location                       = optional(string)<br/>    point_in_time_recovery_enabled = optional(bool, false)<br/>    transaction_log_retention_days = optional(string)<br/>    retained_backups               = optional(number)<br/>    retention_unit                 = optional(string)<br/>  })</pre> | `{}` | no |
| <a name="input_connector_enforcement"></a> [connector\_enforcement](#input\_connector\_enforcement) | Enforce that clients use the connector library | `bool` | `false` | no |
| <a name="input_create_additional_databases"></a> [create\_additional\_databases](#input\_create\_additional\_databases) | Wether A list of databases to be created in your cluster | `bool` | `true` | no |
| <a name="input_create_database"></a> [create\_database](#input\_create\_database) | Whether to create the CloudSQL database | `bool` | `true` | no |
| <a name="input_create_service_networking_connection"></a> [create\_service\_networking\_connection](#input\_create\_service\_networking\_connection) | Whether to create service networking connection | `bool` | `true` | no |
| <a name="input_create_timeout"></a> [create\_timeout](#input\_create\_timeout) | The optional timout that is applied to limit long database creates. | `string` | `"30m"` | no |
| <a name="input_data_cache_enabled"></a> [data\_cache\_enabled](#input\_data\_cache\_enabled) | Whether data cache is enabled for the instance. Defaults to false. Feature is only available for ENTERPRISE\_PLUS tier and supported database\_versions | `bool` | `false` | no |
| <a name="input_database_deletion_policy"></a> [database\_deletion\_policy](#input\_database\_deletion\_policy) | The deletion policy for the database. Setting ABANDON allows the resource to be abandoned rather than deleted. This is useful for Postgres, where databases cannot be deleted from the API if there are users other than cloudsqlsuperuser with access. Possible values are: "ABANDON". | `string` | `null` | no |
| <a name="input_database_flags"></a> [database\_flags](#input\_database\_flags) | The database flags for the master instance. See [more details](https://cloud.google.com/sql/docs/postgres/flags) | <pre>list(object({<br/>    name  = string<br/>    value = string<br/>  }))</pre> | `[]` | no |
| <a name="input_database_version"></a> [database\_version](#input\_database\_version) | The database version to use | `string` | n/a | yes |
| <a name="input_db_charset"></a> [db\_charset](#input\_db\_charset) | The charset for the default database | `string` | `""` | no |
| <a name="input_db_collation"></a> [db\_collation](#input\_db\_collation) | The collation for the default database. Example: 'en\_US.UTF8' | `string` | `""` | no |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | The name of the default database to create | `string` | `"default"` | no |
| <a name="input_delete_timeout"></a> [delete\_timeout](#input\_delete\_timeout) | The optional timout that is applied to limit long database deletes. | `string` | `"30m"` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | Used to block Terraform from deleting a SQL Instance. | `bool` | `true` | no |
| <a name="input_deletion_protection_enabled"></a> [deletion\_protection\_enabled](#input\_deletion\_protection\_enabled) | Enables protection of an instance from accidental deletion across all surfaces (API, gcloud, Cloud Console and Terraform). | `bool` | `false` | no |
| <a name="input_deny_maintenance_period"></a> [deny\_maintenance\_period](#input\_deny\_maintenance\_period) | The Deny Maintenance Period fields to prevent automatic maintenance from occurring during a 90-day time period. List accepts only one value. See [more details](https://cloud.google.com/sql/docs/postgres/maintenance) | <pre>list(object({<br/>    end_date   = string<br/>    start_date = string<br/>    time       = string<br/>  }))</pre> | `[]` | no |
| <a name="input_disk_autoresize"></a> [disk\_autoresize](#input\_disk\_autoresize) | Configuration to increase storage size. | `bool` | `true` | no |
| <a name="input_disk_autoresize_limit"></a> [disk\_autoresize\_limit](#input\_disk\_autoresize\_limit) | The maximum size to which storage can be auto increased. | `number` | `0` | no |
| <a name="input_disk_size"></a> [disk\_size](#input\_disk\_size) | The disk size for the master instance. | `number` | `10` | no |
| <a name="input_disk_type"></a> [disk\_type](#input\_disk\_type) | The disk type for the master instance. | `string` | `"PD_SSD"` | no |
| <a name="input_edition"></a> [edition](#input\_edition) | The edition of the instance, can be ENTERPRISE or ENTERPRISE\_PLUS. | `string` | `null` | no |
| <a name="input_enable_default_db"></a> [enable\_default\_db](#input\_enable\_default\_db) | Enable or disable the creation of the default database | `bool` | `true` | no |
| <a name="input_enable_default_user"></a> [enable\_default\_user](#input\_enable\_default\_user) | Enable or disable the creation of the default user | `bool` | `true` | no |
| <a name="input_enable_random_password_special"></a> [enable\_random\_password\_special](#input\_enable\_random\_password\_special) | Enable special characters in generated random passwords. | `bool` | `false` | no |
| <a name="input_encryption_key_name"></a> [encryption\_key\_name](#input\_encryption\_key\_name) | The full path to the encryption key used for the CMEK disk encryption | `string` | `null` | no |
| <a name="input_follow_gae_application"></a> [follow\_gae\_application](#input\_follow\_gae\_application) | A Google App Engine application whose zone to remain in. Must be in the same region as this instance. | `string` | `null` | no |
| <a name="input_iam_users"></a> [iam\_users](#input\_iam\_users) | A list of IAM users to be created in your CloudSQL instance | <pre>list(object({<br/>    id    = string,<br/>    email = string<br/>  }))</pre> | `[]` | no |
| <a name="input_insights_config"></a> [insights\_config](#input\_insights\_config) | The insights\_config settings for the database. | <pre>object({<br/>    query_plans_per_minute  = optional(number, 5)<br/>    query_string_length     = optional(number, 1024)<br/>    record_application_tags = optional(bool, false)<br/>    record_client_address   = optional(bool, false)<br/>  })</pre> | `null` | no |
| <a name="input_internal_database_ip"></a> [internal\_database\_ip](#input\_internal\_database\_ip) | Whether to create private IP allocation for Cloud SQL | `bool` | `true` | no |
| <a name="input_ip_configuration"></a> [ip\_configuration](#input\_ip\_configuration) | The ip configuration for the master instances. | <pre>object({<br/>    authorized_networks                           = optional(list(map(string)), [])<br/>    ipv4_enabled                                  = optional(bool, true)<br/>    private_network                               = optional(string)<br/>    require_ssl                                   = optional(bool)<br/>    ssl_mode                                      = optional(string)<br/>    allocated_ip_range                            = optional(string)<br/>    enable_private_path_for_google_cloud_services = optional(bool, false)<br/>    psc_enabled                                   = optional(bool, false)<br/>    psc_allowed_consumer_projects                 = optional(list(string), [])<br/>  })</pre> | `{}` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Map of labels for project | `map(string)` | `{}` | no |
| <a name="input_maintenance_window_day"></a> [maintenance\_window\_day](#input\_maintenance\_window\_day) | The day of week (1-7) for the master instance maintenance. | `number` | `1` | no |
| <a name="input_maintenance_window_hour"></a> [maintenance\_window\_hour](#input\_maintenance\_window\_hour) | The hour of day (0-23) maintenance window for the master instance maintenance. | `number` | `23` | no |
| <a name="input_maintenance_window_update_track"></a> [maintenance\_window\_update\_track](#input\_maintenance\_window\_update\_track) | The update track of maintenance window for the master instance maintenance.Can be either `canary` or `stable`. | `string` | `"canary"` | no |
| <a name="input_module_depends_on"></a> [module\_depends\_on](#input\_module\_depends\_on) | List of modules or resources this module depends on. | `list(any)` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the Cloud SQL resources | `string` | `""` | no |
| <a name="input_password_validation_policy_config"></a> [password\_validation\_policy\_config](#input\_password\_validation\_policy\_config) | The password validation policy settings for the database instance. | <pre>object({<br/>    min_length                  = number<br/>    complexity                  = string<br/>    reuse_interval              = number<br/>    disallow_username_substring = bool<br/>    password_change_interval    = string<br/>  })</pre> | `null` | no |
| <a name="input_pricing_plan"></a> [pricing\_plan](#input\_pricing\_plan) | The pricing plan for the master instance. | `string` | `"PER_USE"` | no |
| <a name="input_private_ip_address"></a> [private\_ip\_address](#input\_private\_ip\_address) | Private IP address for allocation | `string` | `null` | no |
| <a name="input_private_ip_prefix_length"></a> [private\_ip\_prefix\_length](#input\_private\_ip\_prefix\_length) | Prefix length for private IP allocation | `number` | `20` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The project ID to manage the Cloud SQL resources | `string` | n/a | yes |
| <a name="input_random_instance_name"></a> [random\_instance\_name](#input\_random\_instance\_name) | Sets random suffix at the end of the Cloud SQL resource name | `bool` | `false` | no |
| <a name="input_read_replica_deletion_protection"></a> [read\_replica\_deletion\_protection](#input\_read\_replica\_deletion\_protection) | Used to block Terraform from deleting replica SQL Instances. | `bool` | `false` | no |
| <a name="input_read_replica_deletion_protection_enabled"></a> [read\_replica\_deletion\_protection\_enabled](#input\_read\_replica\_deletion\_protection\_enabled) | Enables protection of replica instance from accidental deletion across all surfaces (API, gcloud, Cloud Console and Terraform). | `bool` | `false` | no |
| <a name="input_read_replica_name_suffix"></a> [read\_replica\_name\_suffix](#input\_read\_replica\_name\_suffix) | The optional suffix to add to the read instance name | `string` | `""` | no |
| <a name="input_read_replicas"></a> [read\_replicas](#input\_read\_replicas) | List of read replicas to create. Encryption key is required for replica in different region. For replica in same region as master set encryption\_key\_name = null | <pre>list(object({<br/>    name                  = string<br/>    name_override         = optional(string)<br/>    tier                  = optional(string)<br/>    edition               = optional(string)<br/>    availability_type     = optional(string)<br/>    zone                  = optional(string)<br/>    disk_type             = optional(string)<br/>    disk_autoresize       = optional(bool)<br/>    disk_autoresize_limit = optional(number)<br/>    disk_size             = optional(string)<br/>    user_labels           = map(string)<br/>    database_flags = optional(list(object({<br/>      name  = string<br/>      value = string<br/>    })), [])<br/>    insights_config = optional(object({<br/>      query_plans_per_minute  = optional(number, 5)<br/>      query_string_length     = optional(number, 1024)<br/>      record_application_tags = optional(bool, false)<br/>      record_client_address   = optional(bool, false)<br/>    }), null)<br/>    ip_configuration = object({<br/>      authorized_networks                           = optional(list(map(string)), [])<br/>      ipv4_enabled                                  = optional(bool)<br/>      private_network                               = optional(string, )<br/>      require_ssl                                   = optional(bool)<br/>      ssl_mode                                      = optional(string)<br/>      allocated_ip_range                            = optional(string)<br/>      enable_private_path_for_google_cloud_services = optional(bool, false)<br/>      psc_enabled                                   = optional(bool, false)<br/>      psc_allowed_consumer_projects                 = optional(list(string), [])<br/>    })<br/>    encryption_key_name = optional(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_region"></a> [region](#input\_region) | The region of the Cloud SQL resources | `string` | `null` | no |
| <a name="input_root_password"></a> [root\_password](#input\_root\_password) | Initial root password during creation | `string` | `null` | no |
| <a name="input_secondary_zone"></a> [secondary\_zone](#input\_secondary\_zone) | The preferred zone for the secondary/failover instance, it should be something like: `us-central1-a`, `us-east1-c`. | `string` | `null` | no |
| <a name="input_tier"></a> [tier](#input\_tier) | The tier for the master instance. | `string` | `null` | no |
| <a name="input_update_timeout"></a> [update\_timeout](#input\_update\_timeout) | The optional timout that is applied to limit long database updates. | `string` | `"30m"` | no |
| <a name="input_user_deletion_policy"></a> [user\_deletion\_policy](#input\_user\_deletion\_policy) | The deletion policy for the user. Setting ABANDON allows the resource to be abandoned rather than deleted. This is useful for Postgres, where users cannot be deleted from the API if they have been granted SQL roles. Possible values are: "ABANDON". | `string` | `null` | no |
| <a name="input_user_labels"></a> [user\_labels](#input\_user\_labels) | The key/value labels for the master instances. | `map(string)` | `{}` | no |
| <a name="input_user_name"></a> [user\_name](#input\_user\_name) | The name of the default user | `string` | `null` | no |
| <a name="input_user_password"></a> [user\_password](#input\_user\_password) | The password for the default user. If not set, a random one will be generated and available in the generated\_user\_password output variable. | `string` | `""` | no |
| <a name="input_zone"></a> [zone](#input\_zone) | The zone for the master instance, it should be something like: `us-central1-a`, `us-east1-c`. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_additional_users"></a> [additional\_users](#output\_additional\_users) | List of maps of additional users and passwords |
| <a name="output_dns_name"></a> [dns\_name](#output\_dns\_name) | DNS name of the instance endpoint |
| <a name="output_generated_user_password"></a> [generated\_user\_password](#output\_generated\_user\_password) | The auto generated default user password if not input password was provided |
| <a name="output_iam_users"></a> [iam\_users](#output\_iam\_users) | The list of the IAM users with access to the CloudSQL instance |
| <a name="output_instance_connection_name"></a> [instance\_connection\_name](#output\_instance\_connection\_name) | The connection name of the master instance to be used in connection strings |
| <a name="output_instance_first_ip_address"></a> [instance\_first\_ip\_address](#output\_instance\_first\_ip\_address) | The first IPv4 address of the addresses assigned. |
| <a name="output_instance_ip_address"></a> [instance\_ip\_address](#output\_instance\_ip\_address) | The IPv4 address assigned for the master instance |
| <a name="output_instance_name"></a> [instance\_name](#output\_instance\_name) | The instance name for the master instance |
| <a name="output_instance_psc_attachment"></a> [instance\_psc\_attachment](#output\_instance\_psc\_attachment) | The psc\_service\_attachment\_link created for the master instance |
| <a name="output_instance_self_link"></a> [instance\_self\_link](#output\_instance\_self\_link) | The URI of the master instance |
| <a name="output_instance_server_ca_cert"></a> [instance\_server\_ca\_cert](#output\_instance\_server\_ca\_cert) | The CA certificate information used to connect to the SQL instance via SSL |
| <a name="output_instance_service_account_email_address"></a> [instance\_service\_account\_email\_address](#output\_instance\_service\_account\_email\_address) | The service account email address assigned to the master instance |
| <a name="output_instances"></a> [instances](#output\_instances) | A list of all `google_sql_database_instance` resources we've created |
| <a name="output_primary"></a> [primary](#output\_primary) | The `google_sql_database_instance` resource representing the primary instance |
| <a name="output_private_ip_address"></a> [private\_ip\_address](#output\_private\_ip\_address) | The first private (PRIVATE) IPv4 address assigned for the master instance |
| <a name="output_public_ip_address"></a> [public\_ip\_address](#output\_public\_ip\_address) | Primay IPv4 address assigned for the master instance |
| <a name="output_read_replica_instance_names"></a> [read\_replica\_instance\_names](#output\_read\_replica\_instance\_names) | The instance names for the read replica instances |
| <a name="output_replicas"></a> [replicas](#output\_replicas) | A list of `google_sql_database_instance` resources representing the replicas |
| <a name="output_replicas_instance_connection_names"></a> [replicas\_instance\_connection\_names](#output\_replicas\_instance\_connection\_names) | The connection names of the replica instances to be used in connection strings |
| <a name="output_replicas_instance_first_ip_addresses"></a> [replicas\_instance\_first\_ip\_addresses](#output\_replicas\_instance\_first\_ip\_addresses) | The first IPv4 addresses of the addresses assigned for the replica instances |
| <a name="output_replicas_instance_self_links"></a> [replicas\_instance\_self\_links](#output\_replicas\_instance\_self\_links) | The URIs of the replica instances |
| <a name="output_replicas_instance_server_ca_certs"></a> [replicas\_instance\_server\_ca\_certs](#output\_replicas\_instance\_server\_ca\_certs) | The CA certificates information used to connect to the replica instances via SSL |
| <a name="output_replicas_instance_service_account_email_addresses"></a> [replicas\_instance\_service\_account\_email\_addresses](#output\_replicas\_instance\_service\_account\_email\_addresses) | The service account email addresses assigned to the replica instances |
