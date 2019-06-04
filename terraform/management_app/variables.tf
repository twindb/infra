variable "admins" {
    type = "list"
}

variable "environment" {}

variable "management_cidr_block" {}

variable "public_subnet_cidr" {}

variable "private_subnet_cidr" {}

variable "service_name" {}

variable "cloudflare_email" {
    description = "Cloudflare Email Address"
}

variable "cloudflare_token" {
    description = "Global API Key"
}

variable "aws_region" {
  description = "EC2 Region for the VPC"
  default = "us-east-1"
}

variable "keypairs" {
    description = "SSH keys"
    type = "map"
}
