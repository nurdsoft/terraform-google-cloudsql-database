# Multiple Databases Example

This example demonstrates how to create a CloudSQL PostgreSQL instance with multiple databases.

## What This Example Creates

- CloudSQL PostgreSQL instance
- Multiple additional databases (internal-dev, internal-prod)
- Default user with generated password
- IAM users for database access
- SSL configuration with encrypted connections

## Usage

1. Update the variables in `main.tf`:
   - `project_id` - Your GCP project ID
   - `name` - Name for your CloudSQL instance
   - Update IAM users with your actual email addresses
   - Modify database names as needed

2. Initialize and apply:

```bash
terraform init
terraform plan
terraform apply
```

## Features Demonstrated

- Multiple database creation
- Database charset and collation settings
- SSL mode configuration (ENCRYPTED_ONLY)
- IAM authentication
- Advanced labeling strategy

## Clean Up

```bash
terraform destroy
```