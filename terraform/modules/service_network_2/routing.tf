# Routing
# There is a default routing table
resource "aws_default_route_table" "default_rt" {
    default_route_table_id = "${aws_vpc.vpc.default_route_table_id}"
    tags = {
        Name = "${var.environment} ${var.service_name} default route table"
    }
}
# The default route forwards packets to the Internet gateway
resource "aws_route" "ig_route" {
    route_table_id = "${aws_default_route_table.default_rt.id}"
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.ig.id}"
}

# Routing table for the private subnet
resource "aws_route_table" "private_rt" {
    vpc_id = "${aws_vpc.vpc.id}"
    tags = {
        Name = "${var.environment} ${var.service_name} private route table"
    }
}

# The default route in the private routing table forwards packets
# to the NAT gateway
resource "aws_route" "nat_route" {
    route_table_id = "${aws_route_table.private_rt.id}"
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat_gw.id}"
    count = "${var.create_nat}"
}


# The default routing table is associated with the VPC
resource "aws_main_route_table_association" "main_rt_assoc" {
    vpc_id = "${aws_vpc.vpc.id}"
    route_table_id = "${aws_default_route_table.default_rt.id}"
}

# The private routing table is associated with the private subnet
resource "aws_route_table_association" "private_rt_assoc" {
    subnet_id      = "${aws_subnet.private_subnet.id}"
    route_table_id = "${aws_route_table.private_rt.id}"
}
