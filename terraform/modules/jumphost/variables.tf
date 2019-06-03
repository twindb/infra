variable "ami" {
    default = "ami-80861296"
}

variable "instance_type" {
    description = "Type of instance"
    default = "t3.nano"
}

variable "subnet_id" {}

variable "key_pair_name" {
    description = "SSH key pair"
    default = "deployer"
}

variable "root_volume_size" {
    default = 8
}

variable "chef_user" {
    description = "User on chef server. Must be admin"
    default = "chef_twindb"
}
