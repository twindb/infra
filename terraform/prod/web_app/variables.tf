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
