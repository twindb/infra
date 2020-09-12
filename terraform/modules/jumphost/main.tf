resource "aws_instance" "jumphost" {
    ami                     = var.ami
    instance_type           = var.instance_type
    subnet_id               = var.subnet_id
    key_name                = var.key_pair_name
    vpc_security_group_ids  = [
        aws_security_group.jumphost_sg.id
    ]
    root_block_device       {
        volume_size = var.root_volume_size
    }

    tags = {
        Name = "jumphost"
    }
}

resource "aws_security_group" "jumphost_sg" {
    name        = "jumphost_sg"
    description = "Security group for a jumphost. Allows SSH and ICMP."
    vpc_id      = data.aws_subnet.selected.vpc_id

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
}
