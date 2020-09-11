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
  subnet             = "192.168.0.0/24"
  vpc_id             = var.vpc_id
  region             = var.region
  node_id            = "node1"
  registration_queue = var.registration_queue
}

output "nodes" {
  value = {
    "node1" : module.node1.instance.id,
  }
}
