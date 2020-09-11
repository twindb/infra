provider "aws" {
  version = "~> 2.41"
  region  = var.region

}

variable "region" {
  default = "us-east-2"
}
variable "vpc_id" {

}


variable "registration_queue" {
  default = ""
}
module "node1" {
  source             = "github.com/revenants-cie/network-connectivity-tester//integrations/terraform/aws"
  subnet             = "10.1.0.0/24"
  vpc_id             = var.vpc_id
  region             = var.region
  node_id            = "node1"
  registration_queue = var.registration_queue
  //    module_depends_on = [var.nat_gw_public_ip, var.subnets]
}
module "node2" {
  source             = "github.com/revenants-cie/network-connectivity-tester//integrations/terraform/aws"
  subnet             = "10.1.1.0/24"
  vpc_id             = var.vpc_id
  region             = var.region
  node_id            = "node2"
  registration_queue = var.registration_queue
  //    module_depends_on = [var.nat_gw_public_ip, var.subnets]
}
module "node3" {
  source             = "github.com/revenants-cie/network-connectivity-tester//integrations/terraform/aws"
  subnet             = "10.1.2.0/24"
  vpc_id             = var.vpc_id
  region             = var.region
  node_id            = "node3"
  registration_queue = var.registration_queue
  //    module_depends_on = [var.nat_gw_public_ip, var.subnets]
}

output "nodes" {
  value = {
    "node1" : module.node1.instance.id,
    "node2" : module.node2.instance.id,
    "node3" : module.node3.instance.id,
  }
}
