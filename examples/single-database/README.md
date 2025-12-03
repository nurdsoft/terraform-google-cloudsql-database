# Single Database Example

This example demonstrates how to create a single CloudSQL PostgreSQL database with basic configuration.

## What This Example Creates

- CloudSQL PostgreSQL instance
- Single default database
- Default user with generated password
- IAM users for database access
- Basic IP configuration with authorized networks

## Usage

1. Update the variables in `main.tf`:
   - `project_id` - Your GCP project ID
   - `name` - Name for your CloudSQL instance
   - Update IAM users with your actual email addresses

2. Initialize and apply:

```bash
terraform init
terraform plan
terraform apply
```

## Features Demonstrated

- Basic CloudSQL instance setup
- IAM authentication configuration
- Network access control
- User management
- Labeling and organization

## Clean Up

```bash
terraform destroy
```