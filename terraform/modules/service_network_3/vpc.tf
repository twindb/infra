# A separate VPC is created for a service
resource "aws_vpc" "vpc" {
    cidr_block = "${var.vpc_cidr_block}"

    tags {
        Name = "${var.environment} ${var.service_name} VPC"
    }
}
