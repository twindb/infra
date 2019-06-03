data "aws_vpc" "management_vpc" {
    cidr_block = "${var.management_cidr_block}"
}

data "aws_route_tables" "mgmt_route_tables" {
    vpc_id = "${data.aws_vpc.management_vpc.id}"
}


data "aws_route_tables" "my_route_tables" {
    vpc_id = "${aws_vpc.vpc.id}"
}

resource "aws_vpc_peering_connection" "link_to_management" {
  peer_vpc_id = "${data.aws_vpc.management_vpc.id}"
  vpc_id = "${aws_vpc.vpc.id}"
  auto_accept = true
}

# Routes from management VPC to this VPC
resource "aws_route" "route_from_mgmt_to_me" {
    count                     = "${length(data.aws_route_tables.mgmt_route_tables.ids)}"
    route_table_id            = "${data.aws_route_tables.mgmt_route_tables.ids[count.index]}"
    destination_cidr_block    = "${var.vpc_cidr_block}"
    vpc_peering_connection_id = "${aws_vpc_peering_connection.link_to_management.id}"
}

# Routes from this VPC to management VPC
resource "aws_route" "route_from_me_to_mgmt" {
    count                     = "${length(data.aws_route_tables.my_route_tables.ids)}"
    route_table_id            = "${data.aws_route_tables.my_route_tables.ids[count.index]}"
    destination_cidr_block    = "${var.management_cidr_block}"
    vpc_peering_connection_id = "${aws_vpc_peering_connection.link_to_management.id}"
}
