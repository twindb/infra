variable "admins" {
    type = "list"
}

variable "environment" {}

variable "vpc_cidr_block" {}

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

variable "main_aws_key_pair_public_key" {}

variable "secondary_aws_key_pair_name" {}

variable "secondary_aws_key_pair_public_key" {}

