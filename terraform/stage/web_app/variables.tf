variable "cloudflare_email" {
    description = "Cloudflare Email Address"
}

variable "cloudflare_token" {
    description = "Global API Key"
}

variable "vpc_cidr_list" {
  type = "list"
}
variable "vpc_tags" {
  type = "map"
}
variable "web_app_sg_name" {}

variable "vpc_web_subnet_cidr_blocks_staging" {
  type = "list"
}

variable "web_public_subnet_tag_stage" {
  type = "map"
}

variable "web_private_subnet_tag_stage" {
  type = "map"
}

variable "web_private_rt_stage" {
  type = "map"
}

variable "web_default_rt_stage" {
  type = "map"
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

variable "website_uploads_s3_tags" {
  type = "map"
}

variable "website_database_s3_uploads_tags" {
  type = "map"
}
