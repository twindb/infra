# Internet Gateway to let the public network access Internet
resource "aws_internet_gateway" "ig" {
    vpc_id = "${aws_vpc.vpc.id}"

    tags {
        Name = "${var.environment} ${var.service_name} gateway"
    }
}

# NAT gateway translates private addresses of the instances in
# the private subnet. That way they can reach Internet
resource "aws_nat_gateway" "nat_gw" {
    allocation_id = "${aws_eip.nat_eip.id}"
    subnet_id     = "${aws_subnet.public_subnet.id}"
    depends_on = ["aws_internet_gateway.ig"]

    tags {
        Name = "${var.environment} ${var.service_name} nat"
    }
    count = "${var.create_nat}"

}

resource "aws_eip" "nat_eip" {
    vpc = true
    count = "${var.create_nat}"
}
