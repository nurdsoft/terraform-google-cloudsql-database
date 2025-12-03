# Multiple Databases Without Vault Example

This example demonstrates how to create multiple databases using a simplified configuration without HashiCorp Vault integration.

## What This Example Creates

- CloudSQL PostgreSQL instance
- Multiple databases based on configuration
- User management without vault secrets
- Basic IP configuration

## Usage

1. Create a `terraform.tfvars` file:

```hcl
project_id = "your-gcp-project-id"
environment = "dev"
region = "us-central1"
db_version = "POSTGRES_14"
db_zone = "us-central1-c"
db_edition = "ENTERPRISE"
db_tier = "db-f1-micro"
db_user_name = "admin"
db_user_password = "your-secure-password"
db_deletion_protection = false

default_labels = {
  customer = "your-company"
  project = "your-project"
}

additional_dbs = [
  {
    name = "app_db"
    charset = "UTF8"
    collation = "en_US.UTF8"
  },
  {
    name = "analytics_db"
    charset = "UTF8"
    collation = "en_US.UTF8"
  }
]
```

2. Initialize and apply:

```bash
terraform init
terraform plan
terraform apply
```

## Features Demonstrated

- Variable-driven database creation
- Environment-based naming
- Label management
- Simplified configuration approach

## Clean Up

```bash
terraform destroy
```