variable "cloudflare_email" {
    description = "Cloudflare Email Address"
}

variable "cloudflare_token" {
    description = "Global API Key"
}

variable "vpc_recovery_subnets_cidr_blocks_staging" {
  type = "list"
}
variable "recovery_public_subnet_tag_stage" {
  type = "map"
}
variable "recovery_default_rt_stage" {
  type = "map"
}
variable "recovery_private_rt_stage" {
  type = "map"
}
variable "vpc_tags" {
  type = "map"
}
variable "vpc_cidr_list" {
  type = "list"
}

variable "vpc_default_subnet_cidr_blocks" {
  type = "list"
}
variable "default_private_rt_tag" {
  type = "map"

}
variable "default_rt_table_tag" {
  type = "map"
}
variable "sg_recovery_name" {}
