variable "ami" {
    default = "ami-80861296"
}

variable "instance_type" {
    description = "Type of instance"
    default = "t3.medium"
}

variable "vpc_id" {}
variable "subnet_id" {}

variable "aws_region" {
    default = "us-east-1"
}

variable "aws_key_pair_name" {
    description = "Main key pair"
}

variable "name_instance_tag" {
    description = "Value for the Name tag"
    default = "gitlab"

}

variable "root_volume_size" {
    default = 30
}

variable "chef_user" {
    description = "User on chef server. Must be admin"
    default = "chef_twindb"
}
