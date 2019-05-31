variable "cloudflare_email" {
    description = "Cloudflare Email Address"
}

variable "cloudflare_token" {
    description = "Global API Key"
}

variable "default_route_tags" {
    description = "Tags for the default route"
    type = "map"
}

variable "private_route_tags" {
    description = "Tags for the private route"
    type = "map"
}

variable "vpc_cidr_block" {
    description = "IP range assigned to the service network"
}

variable "vpc_tags" {
    description = "Tags for the service VPC"
    type = "map"
}

variable "vpc_web_subnet_cidr_blocks" {
    description = "List of IP ranges of all subnets in the service network"
    type = "list"
}

variable "web_private_subnet_tag" {
    description = "Tags for private subnet"
    type = "map"
}

variable "web_public_subnet_tag" {
    description = "Tags for public subnet"
    type = "map"
}

variable "website_database_s3_uploads_tags" {
    description = "Tags for S3 bucket with database backups"
    type = "map"
}

variable "website_uploads_s3_tags" {
    description = "Tags for S3 bucket with media files for website"
  type = "map"
}

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
