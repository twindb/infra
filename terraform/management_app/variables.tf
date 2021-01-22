variable "admins" {
  type = list(any)
}

variable "environment" {}

variable "management_cidr_block" {}

variable "service_name" {}

variable "aws_region" {
  description = "EC2 Region for the VPC"
  default     = "us-east-1"
}

variable "keypairs" {
  description = "SSH keys"
  type        = map(any)
}

variable "rds_credentials_secret_name" {
  description = "Secret's name where rds credentials are stored"
  default     = "/twindb.com/rds_credentials"
}

variable "rds_username" {
  description = "Username to use to connect to the assigned RDS instance"
}

variable "rds_password" {
  description = "Password to use to connect to the assigned RDS instance"
}

variable "rds_database" {
  description = "Wordpress database name"
}
