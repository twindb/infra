variable "admins" {
    type = list
}

variable "environment" {}

variable "management_cidr_block" {}

variable "service_name" {}

variable "aws_region" {
  description = "EC2 Region for the VPC"
  default = "us-east-1"
}

variable "keypairs" {
    description = "SSH keys"
    type = map
}
