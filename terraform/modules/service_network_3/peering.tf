data "aws_vpc" "management_vpc" {
    cidr_block = "${var.management_cidr_block}"
}

data "aws_route_tables" "mgmt_route_tables" {
    vpc_id = "${data.aws_vpc.management_vpc.id}"
}


resource "aws_vpc_peering_connection" "link_to_management" {
    peer_vpc_id = "${data.aws_vpc.management_vpc.id}"
    vpc_id = "${aws_vpc.vpc.id}"
    auto_accept = true
    count = "${var.not_management_network}"
}

# Routes from management VPC to this VPC
resource "aws_route" "route_from_mgmt_to_me" {
    count                     = "${length(data.aws_route_tables.mgmt_route_tables.ids) * var.not_management_network}"
    route_table_id            = "${data.aws_route_tables.mgmt_route_tables.ids[count.index]}"
    destination_cidr_block    = "${var.vpc_cidr_block}"
    vpc_peering_connection_id = "${aws_vpc_peering_connection.link_to_management.id}"
}

# Routes from this VPC to management VPC
resource "aws_route" "route_from_me_private_to_mgmt" {
    route_table_id            = "${aws_route_table.private_rt.id}"
    destination_cidr_block    = "${var.management_cidr_block}"
    vpc_peering_connection_id = "${aws_vpc_peering_connection.link_to_management.id}"
    count                     = "${var.not_management_network}"
}
resource "aws_route" "route_from_me_public_to_mgmt" {
    route_table_id            = "${aws_default_route_table.default_rt.id}"
    destination_cidr_block    = "${var.management_cidr_block}"
    vpc_peering_connection_id = "${aws_vpc_peering_connection.link_to_management.id}"
    count                     = "${var.not_management_network}"
}
