output "vault_db_path" {
  value       = module.multiple-databases.vault_db_path
  description = "Vault Path where clodusql db configured is added"
}

output "vault_db_role_name" {
  value       = module.multiple-databases.vault_db_role_name
  description = "Cloudsql database vault's role name"
}

output "primary" {
  value       = module.multiple-databases.public_ip_address
  description = "Primay IPv4 address assigned for the master instance"
}

output "instance_name" {
  value       = module.multiple-databases.instance_name
  description = "The instance name for the master instance"
}