vpc_cidr_block = "10.5.0.0/16"

vpc_web_subnet_cidr_blocks = [
    "10.5.0.0/25",
    "10.5.0.128/25"
]

private_route_tags = {
    Name = "Staging private web route table"
}

web_private_subnet_tag = {
    Name = "Staging web private subnet"
}

web_public_subnet_tag = {
    Name = "Staging web public subnet"
}

default_route_tags = {
    Name = "Staging default web route table"
}

