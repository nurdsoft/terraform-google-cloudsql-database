# Shared variables
variable "default_labels" {
  description = "Common labels for all resources"
  type        = map(string)
  default = {
    application                = "test"
    customer                   = "nurdsoft"
    cloud                      = "GCP"
    goog-terraform-provisioned = "true"
    owner                      = "nurdsoft-co"
  }
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "environment" {
  description = "The target environment (e.g., dev, qas, prod, uat)"
  type        = string
  default = "dev"
}

variable "project_id" {
  description = "Project ID"
  type        = string
  default = "virendra-test-459520"
}

variable "create_database" {
  description = "Whether to create the Cloud SQL database"
  type        = bool
  default     = true
}

variable "db_user_name" {
  description = "Database username"
  type        = string
  sensitive   = true
  default     = "master"
}

variable "db_user_password" {
  description = "Database password"
  type        = string
  sensitive   = true
  default     = "123456"
}

variable "db_version" {
  type    = string
  default = "POSTGRES_17"
}

variable "db_zone" {
  type    = string
  default = "us-central1-c"
}

variable "db_edition" {
  type    = string
  default = "ENTERPRISE"
}

variable "db_tier" {
  type    = string
  default = "db-f1-micro"
}

variable "db_deletion_protection" {
  type    = bool
  default = true
}

variable "create_additional_dbs" {
  type    = bool
  default = true
}

variable "additional_dbs" {
  type = list(object({
    name      = string
    charset   = string
    collation = string
  }))
  default = [{ name = "nurdsoft-dev", charset = "UTF8", collation = "en_US.UTF8" }]
}
