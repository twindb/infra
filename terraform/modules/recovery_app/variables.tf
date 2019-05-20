variable "ssl_cert_arn" {
  description = "ARN of SSL certificate"
}

variable "instance_type" {
  description = "Type of instance"
}

variable "instance_count" {
    description = "Number of recovery instances behind ELB"
    default = 1
}

variable "ami" {
  default = "ami-ae7bfdb8"
}

variable "environment" {
  description = "Stage or prod"
}

variable "health_check_target" {
  default = "HTTP:80/"
  description = "Target for check health status"
}

variable "elb_name" {
  description = "Name of elb"
}

variable "key_name" {
  description = "Name of key pair"
}

variable "volume_size" {
  description = "Size of volume"
}

variable "idle_timeout" {}

variable "connection_draining_timeout" {}

variable "recovery_subnet_id" {}

variable "recovery_sg_id" {}

variable "recovery_public_subnet_id" {}

variable "elb_policy_name" {
  default = "twindb-recovery-ssl"
}

