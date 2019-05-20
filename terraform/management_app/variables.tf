variable "cloudflare_email" {
    description = "Cloudflare Email Address"
}

variable "cloudflare_token" {
    description = "Global API Key"
}

variable "vpc_default_subnet_cidr_blocks" {
  type = "list"
}

variable "aws_region" {
  description = "EC2 Region for the VPC"
  default = "us-east-1"
}

variable "vpc_default_tag" {
  type = "map"
}

variable "default_private_subnet_tag" {
  type = "map"
}

variable "default_private_rt_tag" {
  type = "map"
}

variable "default_rt_table_tag" {
  type = "map"
}

variable "default_public_subnet_tag" {
  type = "map"
}

variable "vpc_cidr_list" {
  type = "list"
}
variable "vpc_tags" {
  type = "map"
}

variable "main_aws_key_pair_public_key" {}

variable "secondary_aws_key_pair_name" {}

variable "secondary_aws_key_pair_public_key" {}

