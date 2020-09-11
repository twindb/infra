module "management_network" {
    source = "../modules/terraform-aws-service-network"
    environment           = var.environment
    service_name          = var.service_name
    vpc_cidr_block        = var.management_cidr_block
    management_cidr_block = var.management_cidr_block
    subnets = [
        {
            cidr                    = "10.0.0.0/17"
            availability-zone       = "${var.aws_region}a"
            map_public_ip_on_launch = true
            create_nat              = false
            forward_to              = null
        }
    ]
}

module "jumphost" {
    source = "../modules/jumphost"
    subnet_id = module.management_network.subnet_public_ids[0]
    key_pair_name = "deployer"
    root_volume_size = 16
}
