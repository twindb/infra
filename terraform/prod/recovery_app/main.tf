//data "aws_vpc" "default_vpc" {
//  cidr_block = "${element(var.vpc_cidr_list, 0)}"
//  tags {
//    Name = "${var.vpc_tags[element(var.vpc_cidr_list, 0)]}"
//  }
//}

//module "recovery_app_network" {
//  source = "github.com/twindb/twindb-terraform-modules//network?ref=master"
//  environment = "production"
//  dest_app_name = "recovery"
//  vpc_subnets_cidr_blocks = "${var.vpc_recovery_subnets_cidr_blocks}"
//  public_subnet_tag = "${var.recovery_public_subnet_tag_prod}"
//  default_rt_tag = "${var.recovery_default_rt_prod}"
//  private_subnet_tag = "${var.recovery_private_subnet_tag_prod}"
//  private_rt_tag = "${var.recovery_private_rt_prod}"
//  vpc_tags = "${var.vpc_tags}"
//  vpc_cidr_block = "${element(var.vpc_cidr_list, 1)}"
//}

//resource "aws_vpc_peering_connection" "peering" {
//  peer_vpc_id = "${data.aws_vpc.default_vpc.id}"
//  vpc_id = "${module.recovery_app_network.vpc_id}"
//  auto_accept = true
//}

//resource "aws_route" "private_routes" {
//  route_table_id = "${module.recovery_app_network.private_rt_id}"
//  vpc_peering_connection_id = "${aws_vpc_peering_connection.peering.id}"
//  destination_cidr_block = "${element(var.vpc_default_subnet_cidr_blocks, count.index)}"
//  count = "${length(var.vpc_default_subnet_cidr_blocks)}"
//}
//
//resource "aws_route" "public_routes" {
//  route_table_id = "${module.recovery_app_network.default_rt_id}"
//  vpc_peering_connection_id = "${aws_vpc_peering_connection.peering.id}"
//  destination_cidr_block = "${element(var.vpc_default_subnet_cidr_blocks, count.index)}"
//  count = "${length(var.vpc_default_subnet_cidr_blocks)}"
//}

//data "aws_route_table" "default_private_rt" {
//  vpc_id = "${data.aws_vpc.default_vpc.id}"
//  tags = "${var.default_private_rt_tag}"
//}
//
//data "aws_route_table" "default_public_rt" {
//  vpc_id = "${data.aws_vpc.default_vpc.id}"
//  tags = "${var.default_rt_table_tag}"
//}

//resource "aws_route" "private_routes_to_default" {
//  route_table_id = "${data.aws_route_table.default_private_rt.id}"
//  vpc_peering_connection_id = "${aws_vpc_peering_connection.peering.id}"
//  destination_cidr_block = "${element(var.vpc_cidr_list, 1)}"
//}

//resource "aws_route" "public_routes_to_default" {
//  route_table_id = "${data.aws_route_table.default_public_rt.id}"
//  vpc_peering_connection_id = "${aws_vpc_peering_connection.peering.id}"
//  destination_cidr_block = "${element(var.vpc_cidr_list, 1)}"
//}

//resource "aws_security_group" "recovery_sg" {
//  name = "${var.sg_recovery_name}"
//  description = "Security group for a recovery app. HTTP + HTTPS + ICMP"
//  vpc_id = "${module.recovery_app_network.vpc_id}"
//
//  ingress {
//    from_port = 0
//    to_port = 0
//    protocol = "-1"
//    cidr_blocks = [
//      "0.0.0.0/0"
//    ]
//  }
//
//  egress {
//    protocol = -1
//    from_port = 0
//    to_port = 0
//    cidr_blocks = [
//      "0.0.0.0/0"]
//  }
//
//  tags {
//    Name = "${var.sg_recovery_name}"
//  }
//}

//module "recovery_app" {
//    source = "./../../modules/recovery_app"
//    recovery_subnet_id = "${module.recovery_app_network.private_subnet_id}"
//    recovery_sg_id = "${aws_security_group.recovery_sg.id}"
//    recovery_public_subnet_id = "${module.recovery_app_network.public_subnet_id}"
//    environment = "production"
//    ssl_cert_arn = "arn:aws:acm:us-east-1:100576059692:certificate/6940ec72-1b89-4af0-b34a-9ef44e011d2b"
//    elb_name = "twindb-recovery"
//    key_name = "deployer"
//    instance_type = "t2.medium"
//    idle_timeout = "4000"
//    volume_size = "1024"
//    connection_draining_timeout = "60"
//    instance_count = "0"
//}

//resource "cloudflare_record" "recovery_prod_record" {
//  domain = "twindb.com"
//  name = "recovery"
//  type = "CNAME"
//  value = "${module.recovery_app.elb_dns_record}"
//}
