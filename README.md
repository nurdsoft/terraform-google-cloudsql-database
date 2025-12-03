# terraform-google-cloudsql-database

## Overview

This Terraform configuration sets up a below listed GCP Services:

1.  **CloudSQL - PostgreSQL**: The configuration provisions a CloudSQL - PostgreSQL instance using the  `google_sql_database_instance`  resource. It sets up the instance with specified settings such as tier, edition, activation policy, availability type, deletion protection, encryption, backup configuration, IP configuration, insights configuration, and more.  
    
2.  **Additional Databases**: The configuration creates additional databases within the CloudSQL instance using the  `google_sql_database`  resource. These databases are defined in the  `var.additional_databases`  variable.  
    
3.  **Additional Users**: The configuration creates additional users within the CloudSQL instance using the  `google_sql_user`  resource. These users are defined in the  `var.additional_users`  variable. Passwords for these users are randomly generated using the  `random_password`  resource.  
    
4.  **IAM Users**: The configuration creates IAM users within the CloudSQL instance using the  `google_sql_user`  resource. These users are defined in the  `var.iam_users`  variable. The type of user (CLOUD_IAM_SERVICE_ACCOUNT or CLOUD_IAM_USER) is determined based on the  `is_account_sa`  attribute.  
    
5.  **Replicas**: The configuration sets up replicas of the CloudSQL instance using the  `google_sql_database_instance`  resource. Replicas are defined in the  `var.read_replicas`  variable. Each replica has its own settings and can be configured with different characteristics.

## Usage

`Default - Single Database`:

```hcl
module "single-database" {
  source  = "nurdsoft/cloudsql-database/google"
  version = "0.1.0"
  project_id                  = "zeus-404008"
  name                        = "example-csql"
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
  create_additional_databases = false
  labels = {
    platform_name = "demo"
    cloud         = "gcp"
    component     = "project"
    environment   = "dev"
    client        = "ns"
  }
  iam_users = [{
    id    = "Hello",
    email = "hello@nurdsoft.co"
    }, {
    id    = "Test",
    email = "test@nurdsoft.co"
    },
  ]
  database_flags = [{
    name  = "cloudsql.iam_authentication",
    value = true
  }]
  ip_configuration = {
    ipv4_enabled       = true
    private_network    = null
    require_ssl        = true
    allocated_ip_range = null
    authorized_networks = [{
      name  = "ns-priavte-vpc-cidr"
      value = "10.0.0.0/16"
  }] }
}
```

`Multiple Databases`:

```hcl
module "multiple-databases" {
  source  = "nurdsoft/cloudsql-database/google"
  version = "0.1.0"
  project_id                  = "zeus-404008"
  name                        = "example-csql"
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
  create_additional_databases = false
  additional_databases = [
    {
      name      = "internal-dev"
      charset   = "UTF8"
      collation = "en_US.UTF8"
    }
  ]
  labels = {
    platform_name = "demo"
    cloud         = "gcp"
    component     = "project"
    environment   = "dev"
    client        = "ns"
    app           = "portal"
  }
  iam_users = [{
    id    = "Hello",
    email = "hello@nurdsoft.co"
    }, {
    id    = "Test",
    email = "test@nurdsoft.co"
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
```

## Assumptions

The project assumes the following:

- A basic understanding of [Git](https://git-scm.com/).
- Git version `>= 2.33.0`.
- An existing GCP IAM user or role with access to create/update/delete resources defined in [main.tf](https://github.com/pacenthink/terraform-gcp-modules-project/blob/main/main.tf).
- [GCloud CLI](https://cloud.google.com/sdk/docs/install)  `>= 465.0.0`
- A basic understanding of [Terraform](https://www.terraform.io/).
- Terraform version `>= 1.6.0`
- (Optional - for local testing) A basic understanding of [Make](https://www.gnu.org/software/make/manual/make.html#Introduction).
  - Make version `>= GNU Make 3.81`.
  - **Important Note**: This project includes a [Makefile](https://github.com/pacenthink/terraform-gcp-modules-project/blob/main/Makefile) to speed up local development in Terraform. The `make` targets act as a wrapper around Terraform commands. As such, `make` has only been tested/verified on **Linux/Mac OS**. Though, it is possible to [install make using Chocolatey](https://community.chocolatey.org/packages/make), we **do not** guarantee this approach as it has not been tested/verified. You may use the commands in the [Makefile](https://github.com/pacenthink/terraform-gcp-modules-project/blob/main/Makefile) as a guide to run each Terraform command locally on Windows.

## Test

**Important Note**: This project includes a [Makefile](https://github.com/pacenthink/terraform-gcp-modules-project/blob/main/Makefile) to speed up local development in Terraform. The `make` targets act as a wrapper around Terraform commands. As such, `make` has only been tested/verified on **Linux/Mac OS**. Though, it is possible to [install make using Chocolatey](https://community.chocolatey.org/packages/make), we **do not** guarantee this approach as it has not been tested/verified. You may use the commands in the [Makefile](https://github.com/pacenthink/terraform-gcp-modules-project/blob/main/Makefile) as a guide to run each Terraform command locally on Windows.

```sh
gcloud init # https://cloud.google.com/docs/authentication/gcloud
gcloud auth
make plan
make apply
make destroy
```

## Contributions

Contributions are always welcome. As such, this project uses the `main` branch as the source of truth to track changes.

**Step 1**. Clone this project.

```sh
# Using Git
$ git clone git@github.com:pacenthink/terraform-gcp-modules-cloudsql.git

# Using HTTPS
$ git clone https://github.com/pacenthink/terraform-gcp-modules-cloudsql.git
```

**Step 2**. Checkout a feature branch: `git checkout -b feature/abc`.

**Step 3**. Validate the change/s locally by executing the steps defined under [Test](#test).

**Step 4**. If testing is successful, commit and push the new change/s to the remote.

```sh
$ git add file1 file2 ...

$ git commit -m "Adding some change"

$ git push --set-upstream origin feature/abc
```

**Step 5**. Once pushed, create a [PR](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request) and assign it to a member for review.

- **Important Note**: It can be helpful to attach the `terraform plan` output in the PR.

**Step 6**. A team member reviews/approves/merges the change/s.

**Step 7**. Once merged, deploy the required changes as needed.

**Step 8**. Once deployed, verify that the changes have been deployed.

- If possible, please add a `plan` output using the feature branch so the member reviewing the MR has better visibility in the changes.

## Requirements

| Name | Version |
|------|---------|
| google | 5.16.0 |
| google-beta | 5.16.0 |
| null | 3.2.2 |
| random | 3.6.0 |

## Providers

| Name | Version |
|------|---------|
| google | 5.16.0 |
| google-beta | 5.16.0 |
| null | 3.2.2 |
| random | 3.6.0 |
| time | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| activation\_policy | The activation policy for the master instance.Can be either `ALWAYS`, `NEVER` or `ON_DEMAND`. | `string` | `"ALWAYS"` | no |
| additional\_databases | A list of databases to be created in your cluster | <pre>list(object({<br>    name      = string<br>    charset   = string<br>    collation = string<br>  }))</pre> | `[]` | no |
| additional\_users | A list of users to be created in your cluster. A random password would be set for the user if the `random_password` variable is set. | <pre>list(object({<br>    name            = string<br>    password        = string<br>    random_password = bool<br>  }))</pre> | `[]` | no |
| availability\_type | The availability type for the master instance.This is only used to set up high availability for the PostgreSQL instance. Can be either `ZONAL` or `REGIONAL`. | `string` | `"ZONAL"` | no |
| backup\_configuration | The backup\_configuration settings subblock for the database setings | <pre>object({<br>    enabled                        = optional(bool, false)<br>    start_time                     = optional(string)<br>    location                       = optional(string)<br>    point_in_time_recovery_enabled = optional(bool, false)<br>    transaction_log_retention_days = optional(string)<br>    retained_backups               = optional(number)<br>    retention_unit                 = optional(string)<br>  })</pre> | `{}` | no |
| connector\_enforcement | Enforce that clients use the connector library | `bool` | `false` | no |
| create\_additional\_databases | Wether A list of databases to be created in your cluster | `bool` | `true` | no |
| create\_database | Whether to create the CloudSQL database | `bool` | `true` | no |
| create\_timeout | The optional timout that is applied to limit long database creates. | `string` | `"30m"` | no |
| data\_cache\_enabled | Whether data cache is enabled for the instance. Defaults to false. Feature is only available for ENTERPRISE\_PLUS tier and supported database\_versions | `bool` | `false` | no |
| database\_deletion\_policy | The deletion policy for the database. Setting ABANDON allows the resource to be abandoned rather than deleted. This is useful for Postgres, where databases cannot be deleted from the API if there are users other than cloudsqlsuperuser with access. Possible values are: "ABANDON". | `string` | `null` | no |
| database\_flags | The database flags for the master instance. See [more details](https://cloud.google.com/sql/docs/postgres/flags) | <pre>list(object({<br>    name  = string<br>    value = string<br>  }))</pre> | `[]` | no |
| database\_version | The database version to use | `string` | n/a | yes |
| db\_charset | The charset for the default database | `string` | `""` | no |
| db\_collation | The collation for the default database. Example: 'en\_US.UTF8' | `string` | `""` | no |
| db\_name | The name of the default database to create | `string` | `"default"` | no |
| delete\_timeout | The optional timout that is applied to limit long database deletes. | `string` | `"30m"` | no |
| deletion\_protection | Used to block Terraform from deleting a SQL Instance. | `bool` | `true` | no |
| deletion\_protection\_enabled | Enables protection of an instance from accidental deletion across all surfaces (API, gcloud, Cloud Console and Terraform). | `bool` | `false` | no |
| deny\_maintenance\_period | The Deny Maintenance Period fields to prevent automatic maintenance from occurring during a 90-day time period. List accepts only one value. See [more details](https://cloud.google.com/sql/docs/postgres/maintenance) | <pre>list(object({<br>    end_date   = string<br>    start_date = string<br>    time       = string<br>  }))</pre> | `[]` | no |
| disk\_autoresize | Configuration to increase storage size. | `bool` | `true` | no |
| disk\_autoresize\_limit | The maximum size to which storage can be auto increased. | `number` | `0` | no |
| disk\_size | The disk size for the master instance. | `number` | `10` | no |
| disk\_type | The disk type for the master instance. | `string` | `"PD_SSD"` | no |
| edition | The edition of the instance, can be ENTERPRISE or ENTERPRISE\_PLUS. | `string` | `null` | no |
| enable\_default\_db | Enable or disable the creation of the default database | `bool` | `true` | no |
| enable\_default\_user | Enable or disable the creation of the default user | `bool` | `true` | no |
| enable\_random\_password\_special | Enable special characters in generated random passwords. | `bool` | `false` | no |
| encryption\_key\_name | The full path to the encryption key used for the CMEK disk encryption | `string` | `null` | no |
| follow\_gae\_application | A Google App Engine application whose zone to remain in. Must be in the same region as this instance. | `string` | `null` | no |
| iam\_users | A list of IAM users to be created in your CloudSQL instance | <pre>list(object({<br>    id    = string,<br>    email = string<br>  }))</pre> | `[]` | no |
| insights\_config | The insights\_config settings for the database. | <pre>object({<br>    query_plans_per_minute  = optional(number, 5)<br>    query_string_length     = optional(number, 1024)<br>    record_application_tags = optional(bool, false)<br>    record_client_address   = optional(bool, false)<br>  })</pre> | `null` | no |
| ip\_configuration | The ip configuration for the master instances. | <pre>object({<br>    authorized_networks                           = optional(list(map(string)), [])<br>    ipv4_enabled                                  = optional(bool, true)<br>    private_network                               = optional(string)<br>    require_ssl                                   = optional(bool)<br>    ssl_mode                                      = optional(string)<br>    allocated_ip_range                            = optional(string)<br>    enable_private_path_for_google_cloud_services = optional(bool, false)<br>    psc_enabled                                   = optional(bool, false)<br>    psc_allowed_consumer_projects                 = optional(list(string), [])<br>  })</pre> | `{}` | no |
| labels | Map of labels for project | `map(string)` | `{}` | no |
| maintenance\_window\_day | The day of week (1-7) for the master instance maintenance. | `number` | `1` | no |
| maintenance\_window\_hour | The hour of day (0-23) maintenance window for the master instance maintenance. | `number` | `23` | no |
| maintenance\_window\_update\_track | The update track of maintenance window for the master instance maintenance.Can be either `canary` or `stable`. | `string` | `"canary"` | no |
| module\_depends\_on | List of modules or resources this module depends on. | `list(any)` | `[]` | no |
| name | The name of the Cloud SQL resources | `string` | `""` | no |
| password\_validation\_policy\_config | The password validation policy settings for the database instance. | <pre>object({<br>    min_length                  = number<br>    complexity                  = string<br>    reuse_interval              = number<br>    disallow_username_substring = bool<br>    password_change_interval    = string<br>  })</pre> | `null` | no |
| pricing\_plan | The pricing plan for the master instance. | `string` | `"PER_USE"` | no |
| project\_id | The project ID to manage the Cloud SQL resources | `string` | n/a | yes |
| random\_instance\_name | Sets random suffix at the end of the Cloud SQL resource name | `bool` | `false` | no |
| read\_replica\_deletion\_protection | Used to block Terraform from deleting replica SQL Instances. | `bool` | `false` | no |
| read\_replica\_deletion\_protection\_enabled | Enables protection of replica instance from accidental deletion across all surfaces (API, gcloud, Cloud Console and Terraform). | `bool` | `false` | no |
| read\_replica\_name\_suffix | The optional suffix to add to the read instance name | `string` | `""` | no |
| read\_replicas | List of read replicas to create. Encryption key is required for replica in different region. For replica in same region as master set encryption\_key\_name = null | <pre>list(object({<br>    name                  = string<br>    name_override         = optional(string)<br>    tier                  = optional(string)<br>    edition               = optional(string)<br>    availability_type     = optional(string)<br>    zone                  = optional(string)<br>    disk_type             = optional(string)<br>    disk_autoresize       = optional(bool)<br>    disk_autoresize_limit = optional(number)<br>    disk_size             = optional(string)<br>    user_labels           = map(string)<br>    database_flags = optional(list(object({<br>      name  = string<br>      value = string<br>    })), [])<br>    insights_config = optional(object({<br>      query_plans_per_minute  = optional(number, 5)<br>      query_string_length     = optional(number, 1024)<br>      record_application_tags = optional(bool, false)<br>      record_client_address   = optional(bool, false)<br>    }), null)<br>    ip_configuration = object({<br>      authorized_networks                           = optional(list(map(string)), [])<br>      ipv4_enabled                                  = optional(bool)<br>      private_network                               = optional(string, )<br>      require_ssl                                   = optional(bool)<br>      ssl_mode                                      = optional(string)<br>      allocated_ip_range                            = optional(string)<br>      enable_private_path_for_google_cloud_services = optional(bool, false)<br>      psc_enabled                                   = optional(bool, false)<br>      psc_allowed_consumer_projects                 = optional(list(string), [])<br>    })<br>    encryption_key_name = optional(string)<br>  }))</pre> | `[]` | no |
| region | The region of the Cloud SQL resources | `string` | `null` | no |
| root\_password | Initial root password during creation | `string` | `null` | no |
| secondary\_zone | The preferred zone for the secondary/failover instance, it should be something like: `us-central1-a`, `us-east1-c`. | `string` | `null` | no |
| tier | The tier for the master instance. | `string` | `null` | no |
| update\_timeout | The optional timout that is applied to limit long database updates. | `string` | `"30m"` | no |
| user\_deletion\_policy | The deletion policy for the user. Setting ABANDON allows the resource to be abandoned rather than deleted. This is useful for Postgres, where users cannot be deleted from the API if they have been granted SQL roles. Possible values are: "ABANDON". | `string` | `null` | no |
| user\_labels | The key/value labels for the master instances. | `map(string)` | `{}` | no |
| user\_name | The name of the default user | `string` | `null` | no |
| user\_password | The password for the default user. If not set, a random one will be generated and available in the generated\_user\_password output variable. | `string` | `""` | no |
| zone | The zone for the master instance, it should be something like: `us-central1-a`, `us-east1-c`. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| additional\_users | List of maps of additional users and passwords |
| dns\_name | DNS name of the instance endpoint |
| generated\_user\_password | The auto generated default user password if not input password was provided |
| iam\_users | The list of the IAM users with access to the CloudSQL instance |
| instance\_connection\_name | The connection name of the master instance to be used in connection strings |
| instance\_first\_ip\_address | The first IPv4 address of the addresses assigned. |
| instance\_ip\_address | The IPv4 address assigned for the master instance |
| instance\_name | The instance name for the master instance |
| instance\_psc\_attachment | The psc\_service\_attachment\_link created for the master instance |
| instance\_self\_link | The URI of the master instance |
| instance\_server\_ca\_cert | The CA certificate information used to connect to the SQL instance via SSL |
| instance\_service\_account\_email\_address | The service account email address assigned to the master instance |
| instances | A list of all `google_sql_database_instance` resources we've created |
| primary | The `google_sql_database_instance` resource representing the primary instance |
| private\_ip\_address | The first private (PRIVATE) IPv4 address assigned for the master instance |
| public\_ip\_address | Primay IPv4 address assigned for the master instance |
| read\_replica\_instance\_names | The instance names for the read replica instances |
| replicas | A list of `google_sql_database_instance` resources representing the replicas |
| replicas\_instance\_connection\_names | The connection names of the replica instances to be used in connection strings |
| replicas\_instance\_first\_ip\_addresses | The first IPv4 addresses of the addresses assigned for the replica instances |
| replicas\_instance\_self\_links | The URIs of the replica instances |
| replicas\_instance\_server\_ca\_certs | The CA certificates information used to connect to the replica instances via SSL |
| replicas\_instance\_service\_account\_email\_addresses | The service account email addresses assigned to the replica instances |

## Authors

Module is maintained by [Nurdsoft](https://github.com/nurdsoft).

---

## License

Apache 2 Licensed. See [LICENSE](https://github.com/nurdsoft/terraform-google-cloudsql-database/tree/main/LICENSE) for full details.