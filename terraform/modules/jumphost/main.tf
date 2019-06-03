resource "aws_instance" "jumphost" {
    ami                     = "${var.ami}"
    instance_type           = "${var.instance_type}"
    subnet_id               = "${var.subnet_id}"
    key_name                = "${var.key_pair_name}"
    vpc_security_group_ids  = [
        "${aws_security_group.jumphost_sg.id}"
    ]
    root_block_device       = {
        volume_size = "${var.root_volume_size}"
    }

    tags {
        Name = "jumphost"
    }

    provisioner "chef" {
        version = "14.12.9"
        node_name = "jumphost"
        recreate_client = true
        server_url = "https://api.chef.io/organizations/twindb"
        run_list = [
            "role[jumphost]"
        ]
        user_key = "${file("../../.env/${var.chef_user}.pem")}"
        secret_key = "${file("../../.env/encrypted_data_bag_secret")}"
        user_name = "${var.chef_user}"
        connection {
            host = "${self.public_ip}"
            user = "ubuntu"
            private_key = "${file("../../.env/deployer.key")}"
        }
    }

}

resource "aws_eip" "jumphost_eip" {
  instance  = "${aws_instance.jumphost.id}"
  vpc       = true
}
resource "aws_eip_association" "jumphost_assoc" {
  instance_id   = "${aws_instance.jumphost.id}"
  allocation_id = "${aws_eip.jumphost_eip.id}"
}

resource "cloudflare_record" "jumphost_record" {
    domain  = "twindb.com"
    name    = "jumphost"
    type    = "A"
    value   = "${aws_eip.jumphost_eip.public_ip}"
}

resource "aws_security_group" "jumphost_sg" {
    name        = "jumphost_sg"
    description = "Security group for a jumphost. Allows SSH and ICMP."
    vpc_id      = "${data.aws_subnet.selected.vpc_id}"

    ingress {
        from_port   = -1
        to_port     = -1
        protocol    = "icmp"
        cidr_blocks = [
            "0.0.0.0/0"
        ]
    }

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = [
            "0.0.0.0/0"
        ]
    }

    egress {
        protocol    = -1
        from_port   = 0
        to_port     = 0
        cidr_blocks = [
            "0.0.0.0/0"
        ]
    }

    tags {
        Name = "jumphost_sg"
    }
}
