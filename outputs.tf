output "instance_name" {
  value       = google_sql_database_instance.sql_database_instance[0].name
  description = "The instance name for the master instance"
}

output "public_ip_address" {
  value       = google_sql_database_instance.sql_database_instance[0].public_ip_address
  description = "Primay IPv4 address assigned for the master instance"
}

output "private_ip_address" {
  value       = google_sql_database_instance.sql_database_instance[0].private_ip_address
  description = "The first private (PRIVATE) IPv4 address assigned for the master instance"
}

output "instance_ip_address" {
  value       = google_sql_database_instance.sql_database_instance[0].ip_address
  description = "The IPv4 address assigned for the master instance"
}

output "instance_first_ip_address" {
  value       = google_sql_database_instance.sql_database_instance[0].first_ip_address
  description = "The first IPv4 address of the addresses assigned."
}

output "instance_connection_name" {
  value       = google_sql_database_instance.sql_database_instance[0].connection_name
  description = "The connection name of the master instance to be used in connection strings"
}

output "instance_self_link" {
  value       = google_sql_database_instance.sql_database_instance[0].self_link
  description = "The URI of the master instance"
}

output "instance_server_ca_cert" {
  value       = google_sql_database_instance.sql_database_instance[0].server_ca_cert
  description = "The CA certificate information used to connect to the SQL instance via SSL"
  sensitive   = true
}

output "instance_service_account_email_address" {
  value       = google_sql_database_instance.sql_database_instance[0].service_account_email_address
  description = "The service account email address assigned to the master instance"
}

output "instance_psc_attachment" {
  value       = google_sql_database_instance.sql_database_instance[0].psc_service_attachment_link
  description = "The psc_service_attachment_link created for the master instance"
}

output "replicas_instance_first_ip_addresses" {
  value       = [for r in google_sql_database_instance.sql_database_instance_replica : r.ip_address]
  description = "The first IPv4 addresses of the addresses assigned for the replica instances"
}

output "replicas_instance_connection_names" {
  value       = [for r in google_sql_database_instance.sql_database_instance_replica : r.connection_name]
  description = "The connection names of the replica instances to be used in connection strings"
}

output "replicas_instance_self_links" {
  value       = [for r in google_sql_database_instance.sql_database_instance_replica : r.self_link]
  description = "The URIs of the replica instances"
}

output "replicas_instance_server_ca_certs" {
  value       = [for r in google_sql_database_instance.sql_database_instance_replica : r.server_ca_cert]
  description = "The CA certificates information used to connect to the replica instances via SSL"
  sensitive   = true
}

output "replicas_instance_service_account_email_addresses" {
  value       = [for r in google_sql_database_instance.sql_database_instance_replica : r.service_account_email_address]
  description = "The service account email addresses assigned to the replica instances"
}

output "read_replica_instance_names" {
  value       = [for r in google_sql_database_instance.sql_database_instance_replica : r.name]
  description = "The instance names for the read replica instances"
}

output "generated_user_password" {
  description = "The auto generated default user password if not input password was provided"
  value       = random_password.user_password[0].result
  sensitive   = true
}

output "additional_users" {
  description = "List of maps of additional users and passwords"
  value = [for r in google_sql_user.additional_users :
    {
      name     = r.name
      password = r.password
    }
  ]
  sensitive = true
}

output "iam_users" {
  description = "The list of the IAM users with access to the CloudSQL instance"
  value       = var.iam_users
}

output "primary" {
  value       = google_sql_database_instance.sql_database_instance
  description = "The `google_sql_database_instance` resource representing the primary instance"
  sensitive   = true
}

output "replicas" {
  value       = values(google_sql_database_instance.sql_database_instance_replica)
  description = "A list of `google_sql_database_instance` resources representing the replicas"
  sensitive   = true
}

output "instances" {
  value       = concat([google_sql_database_instance.sql_database_instance], values(google_sql_database_instance.sql_database_instance_replica))
  description = "A list of all `google_sql_database_instance` resources we've created"
  sensitive   = true
}

output "dns_name" {
  value       = google_sql_database_instance.sql_database_instance[0].dns_name
  description = "DNS name of the instance endpoint"
}
