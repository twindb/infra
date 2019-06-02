data "aws_vpc" "management_vpc" {
    cidr_block = "${var.management_cidr_block}"
}

resource "aws_vpc_peering_connection" "link_to_management" {
  peer_vpc_id = "${data.aws_vpc.management_vpc.id}"
  vpc_id = "${aws_vpc.vpc.id}"
  auto_accept = true
}
