resource "aws_security_group" "gitlab_sg" {
    name = "gitlab_sg"
    description = "Security group for the GitLab master. Allows SSH, HTTP (8080) and ICMP."
    vpc_id = "${var.vpc_id}"

    ingress {
        from_port = 0
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [
            "0.0.0.0/0"
        ]
    }

    ingress {
        from_port = 0
        to_port = 8080
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
        Name = "gitlab_sg"
    }
}
