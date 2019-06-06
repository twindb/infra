# Subnets for the service. Two subnets are created.
# One is for instances with public addresses. It is called public.
# One is for instance with private only adrresses. It is called private.
resource "aws_subnet" "public_subnet" {
    cidr_block              = "${var.public_subnet_cidr}"
    vpc_id                  = "${aws_vpc.vpc.id}"
    availability_zone       = "${format("%s%s", var.aws_region, var.availability_zone_suffix)}"
    map_public_ip_on_launch = true
    tags                    = {
        Name = "${var.environment} ${var.service_name} public subnet"
    }
}

resource "aws_subnet" "private_subnet" {
    cidr_block        = "${var.private_subnet_cidr}"
    vpc_id            = "${aws_vpc.vpc.id}"
    availability_zone = "${format("%s%s", var.aws_region, var.availability_zone_suffix)}"
    tags              = {
        Name = "${var.environment} ${var.service_name} private subnet"
    }
}
