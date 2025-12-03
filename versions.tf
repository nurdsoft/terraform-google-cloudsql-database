terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "3.2.2"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "5.16.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "5.16.0"
    }
  }
}