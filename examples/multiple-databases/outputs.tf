output "primary" {
  value       = module.multiple-databases.public_ip_address
  description = "Primay IPv4 address assigned for the master instance"
}

output "instance_name" {
  value       = module.multiple-databases.instance_name
  description = "The instance name for the master instance"
}