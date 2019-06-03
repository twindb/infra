module "management_network" {
    source = "../modules/service_network_3"
    environment = "${var.environment}"
    service_name = "${var.service_name}"

    vpc_cidr_block = "${var.management_cidr_block}"
    public_subnet_cidr = "${var.public_subnet_cidr}"
    private_subnet_cidr = "${var.private_subnet_cidr}"

    create_nat = false
    management_cidr_block = "${var.management_cidr_block}"
    not_management_network = false
}

module "jumphost" {
    source = "../modules/jumphost"
    subnet_id = "${module.management_network.public_subnet_id}"
    key_pair_name = "deployer"
    root_volume_size = 16
}
