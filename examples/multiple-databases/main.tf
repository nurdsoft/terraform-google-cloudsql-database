module "multiple-databases" {
  source  = "nurdsoft/cloudsql-database/google"
  version = "0.1.0"
  project_id                  = "zeus-404008"
  name                        = "example-csql-v1"
  random_instance_name        = false
  database_version            = "POSTGRES_14"
  zone                        = "us-central1-c"
  region                      = "us-central1"
  edition                     = "ENTERPRISE"
  tier                        = "db-f1-micro"
  user_name                   = "master"
  user_password               = ""
  data_cache_enabled          = false
  deletion_protection         = false
  create_additional_databases = true
  additional_databases = [
    {
      name      = "internal-dev"
      charset   = "UTF8"
      collation = "en_US.UTF8"
    },
    {
      name      = "internal-prod"
      charset   = "UTF8"
      collation = "en_US.UTF8"
    },

  ]
  labels = {
    platform_name = "demo"
    cloud         = "gcp"
    component     = "project"
    environment   = "dev"
    client        = "ns"
    application   = "internal"
  }
  iam_users = [{
    id    = "Hello",
    email = "hello@nurdsoft.co"
    }, {
    id    = "Test",
    email = "test.@nurdsoft.co"
    },
  ]
  database_flags = [{
    name  = "cloudsql.iam_authentication",
    value = true
  }]
  ip_configuration = {
    ipv4_enabled       = true
    private_network    = null
    require_ssl        = false
    ssl_mode           = "ENCRYPTED_ONLY"
    allocated_ip_range = null
    authorized_networks = [{
      name  = "ns-priavte-vpc-cidr"
      value = "0.0.0.0/0"
  }] }
}
