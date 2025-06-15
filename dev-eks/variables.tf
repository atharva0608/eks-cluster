variable "region" {}
variable "profile" {}

variable "vpc_cidr" {}
variable "public_subnets" { type = list(string) }
variable "private_subnets" { type = list(string) }
variable "azs" { type = list(string) }

variable "cluster_name" {}
variable "ssh_key_name" {}
variable "admin_user" {
  description = "Admin IAM user to be added to aws-auth"
  type        = string
}

variable "account_id" {
  description = "AWS account ID"
  type        = string
}
