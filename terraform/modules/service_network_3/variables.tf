variable "create_nat" {
    default = true
}

variable "environment" {}

variable "management_cidr_block" {
    description = "Management VPC cidr block"
}

variable "private_subnet_cidr" {
    description = "IP range for private network"
}

variable "public_subnet_cidr" {
    description = "IP range for private network"
}

variable "service_name" {}

variable "vpc_cidr_block" {}

