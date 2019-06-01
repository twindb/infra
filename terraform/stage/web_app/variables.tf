variable "cloudflare_email" {
    description = "Cloudflare Email Address"
}

variable "cloudflare_token" {
    description = "Global API Key"
}

variable "environment" {}

variable "private_subnet_cidr" {}

variable "public_subnet_cidr" {}

variable "vpc_cidr_block" {
    description = "IP range assigned to the service network"
}

variable "service_name" {}

//variable "website_database_s3_uploads_tags" {
//    description = "Tags for S3 bucket with database backups"
//    type = "map"
//}
//
//variable "website_uploads_s3_tags" {
//    description = "Tags for S3 bucket with media files for website"
//  type = "map"
//}

//variable "web_app_sg_name" {}
//
//variable "vpc_default_subnet_cidr_blocks" {
//  type = "list"
//}
//
//variable "default_private_rt_tag" {
//  type = "map"
//}
//
//variable "default_rt_table_tag" {
//  type = "map"
//}
