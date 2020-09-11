provider "aws" {
  version = "~> 2.41"
  region  = var.region

}

variable "region" {
  default = "us-east-2"
}
variable "vpc_id" {

}
variable "mgmt_vpc_id" {

}


variable "registration_queue" {
  default = ""
}
module "mgmt_node1" {
  source             = "github.com/revenants-cie/network-connectivity-tester//integrations/terraform/aws"
  subnet             = "10.0.0.0/24"
  vpc_id             = var.mgmt_vpc_id
  region             = var.region
  node_id            = "mgmt_node1"
  registration_queue = var.registration_queue
}

module "node1" {
  source             = "github.com/revenants-cie/network-connectivity-tester//integrations/terraform/aws"
  subnet             = "10.1.0.0/24"
  vpc_id             = var.vpc_id
  region             = var.region
  node_id            = "node1"
  registration_queue = var.registration_queue
}

module "node2" {
  source             = "github.com/revenants-cie/network-connectivity-tester//integrations/terraform/aws"
  subnet             = "10.1.1.0/24"
  vpc_id             = var.vpc_id
  region             = var.region
  node_id            = "node2"
  registration_queue = var.registration_queue
}

module "node3" {
  source             = "github.com/revenants-cie/network-connectivity-tester//integrations/terraform/aws"
  subnet             = "10.1.2.0/24"
  vpc_id             = var.vpc_id
  region             = var.region
  node_id            = "node3"
  registration_queue = var.registration_queue
}

module "node4" {
  source             = "github.com/revenants-cie/network-connectivity-tester//integrations/terraform/aws"
  subnet             = "10.1.3.0/24"
  vpc_id             = var.vpc_id
  region             = var.region
  node_id            = "node4"
  registration_queue = var.registration_queue
}

output "nodes" {
  value = {
    "mgmt_node1" : module.mgmt_node1.instance.id,
    "node1" : module.node1.instance.id,
    "node2" : module.node2.instance.id,
    "node3" : module.node3.instance.id,
    "node4" : module.node4.instance.id,
  }
}
