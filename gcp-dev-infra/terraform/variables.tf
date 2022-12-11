variable "env" {}
variable "gcp_project" {}
variable "region" {}
variable "zone" {}

variable "gitlab_machine_type" {}
variable "gitlab_source_image" {}
variable "gitlab_disk_size_gb" {}

variable "gitlab_email_from" {}
variable "smtp_address" {}
variable "smtp_user_name" {}
variable "smtp_password" {}
variable "smtp_domain" {}

# https://cloud.google.com/iap/docs/using-tcp-forwarding?hl=ja
variable "gcp_iap_cidr" {
  default = "35.235.240.0/20"
}

variable "my-zone-resource-name" {}
variable "my-dns-name" {}
variable "my_global_ip" {}
variable "gitlab_storage_lifecycle_delete_age" {}