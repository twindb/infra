module "management_network" {
    source = "../modules/service_network_2"
    environment = "${var.environment}"
    service_name = "${var.service_name}"

    vpc_cidr_block = "${var.management_cidr_block}"
    public_subnet_cidr = "${var.public_subnet_cidr}"
    private_subnet_cidr = "${var.private_subnet_cidr}"

    create_nat = 0
}

resource "aws_security_group" "jumphost_sg" {
  name = "jumphost_sg"
  description = "Security group for a jumphost. Allows SSH and ICMP."
  vpc_id = "${module.management_network.vpc_id}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  egress {
    protocol = -1
    from_port = 0
    to_port = 0
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags {
    Name = "jumphost_sg"
  }
}

module "management_app" {
    source = "../modules/managment_app/"
    sg_id = "${aws_security_group.jumphost_sg.id}"
    subnet_id = "${module.management_network.public_subnet_id}"
    aws_region = "${var.aws_region}"
    instance_type = "t2.micro"
    main_aws_key_pair_name = "deployer"
    main_aws_key_pair_public_key = "${var.main_aws_key_pair_public_key}"
    jumphost_instance_tag = "jumphost"
    root_volume_size = 16
}

resource "aws_key_pair" "secondary_key_pair" {
  key_name   = "${var.secondary_aws_key_pair_name}"
  public_key = "${var.secondary_aws_key_pair_public_key}"
}

resource "cloudflare_record" "jumphost_record" {
  domain = "twindb.com"
  name = "jumphost"
  type = "A"
  value = "${module.management_app.public_jumhost_ip}"
}

# User for CI of chef repo
