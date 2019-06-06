variable "availability_zone_suffix" {
    description = "Availability zone it calculated ad region + the suffix"
    default     = "a"
}

variable "create_nat" {
    default = true
}

variable "environment" {}

variable "management_cidr_block" {
    description = "Management VPC cidr block"
}

variable "not_management_network" {
    description = "True if this is NOT a management VPC"
    default = true
}

variable "private_subnet_cidr" {
    description = "IP range for private network"
}

variable "public_subnet_cidr" {
    description = "IP range for private network"
}

variable "aws_region" {
    description = "AWS region"
    default     = "us-east-1"
}

variable "service_name" {}

variable "vpc_cidr_block" {}

