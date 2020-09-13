module "management_network" {
  source                = "../modules/terraform-aws-service-network"
  environment           = var.environment
  service_name          = var.service_name
  vpc_cidr_block        = var.management_cidr_block
  management_cidr_block = var.management_cidr_block
  enable_dns_hostnames  = true
  subnets = [
    {
      cidr                    = "10.0.0.0/24"
      availability-zone       = "${var.aws_region}a"
      map_public_ip_on_launch = true
      create_nat              = true
      forward_to              = null
    },
    {
      cidr                    = "10.0.1.0/24"
      availability-zone       = "${var.aws_region}b"
      map_public_ip_on_launch = true
      create_nat              = true
      forward_to              = null
    },
    {
      cidr                    = "10.0.2.0/24"
      availability-zone       = "${var.aws_region}a"
      map_public_ip_on_launch = false
      create_nat              = false
      forward_to              = "10.0.0.0/24"
    },
    {
      cidr                    = "10.0.3.0/24"
      availability-zone       = "${var.aws_region}b"
      map_public_ip_on_launch = false
      create_nat              = false
      forward_to              = "10.0.1.0/24"
    }
  ]
}

module "jumphost" {
  source           = "../modules/jumphost"
  subnet_id        = module.management_network.subnet_public_ids[0]
  key_pair_name    = "deployer"
  root_volume_size = 16
}

resource "aws_route53_record" "jumphost" {
  name    = "jumphost"
  type    = "A"
  zone_id = aws_route53_zone.twindb_com.id
  ttl     = 300
  records = [
    module.jumphost.public_jumhost_ip
  ]
}
