variable "ami" {
    description = "AMI"
    default     = "ami-80861296"
}

variable "data_volume_type" {
    description = "EBS volume type"
    default     = "gp2"
}
variable "data_volume_size" {
    description = "Data volume size, GB"
    default     = "8"
}

variable "environment" {
    description = "Name for environment"
    default     = "stage"
}

variable "instance_type" {
    description = "EC2 instance type"
    default     = "t3.nano"
}

variable "key_name" {
    description = "SSH key name"
}

variable "root_volume_type" {
    description = "EBS volume type"
    default     = "gp2"
}
variable "root_volume_size" {
    description = "Root volume size, GB"
    default     = "8"
}

variable "subnet_id" {
    description = "Subnet where to launch instances"
}

variable "security_group_id" {
    description = "Security group id"
}

