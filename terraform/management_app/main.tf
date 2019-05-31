module "management_network" {
  source = "../modules/service_network"
  environment = "production"
  dest_app_name = "jumphost"
  vpc_subnets_cidr_blocks = "${var.vpc_default_subnet_cidr_blocks}"
  public_subnet_tag = "${var.default_public_subnet_tag}"
  default_rt_tag = "${var.default_rt_table_tag}"
  private_subnet_tag = "${var.default_private_subnet_tag}"
  private_rt_tag = "${var.default_private_rt_tag}"
  vpc_tags = "${var.vpc_tags}"
  vpc_cidr_block = "${element(var.vpc_cidr_list, 0)}"
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
      "0.0.0.0/0"]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  egress {
    protocol = -1
    from_port = 0
    to_port = 0
    cidr_blocks = [
      "0.0.0.0/0"]
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

### TESTING ###

resource "aws_vpc" "testing_vpc" {
  cidr_block = "${element(var.vpc_cidr_list, 3)}"

  tags {
    Name = "${var.vpc_tags[element(var.vpc_cidr_list, 3)]}"
  }
}

resource "aws_subnet" "testing_vpc_subnet" {
  cidr_block = "${element(var.vpc_cidr_list, 3)}"
  vpc_id = "${aws_vpc.testing_vpc.id}"
  map_public_ip_on_launch = true
  tags {
    Name = "Testing subnet"
  }
}

resource "aws_internet_gateway" "testing" {
  vpc_id = "${aws_vpc.testing_vpc.id}"
}

resource "aws_default_route_table" "testing" {
  default_route_table_id = "${aws_vpc.testing_vpc.default_route_table_id}"
  tags {
    Name = "Main routing table for VPC testing"
  }

}

resource "aws_vpc_peering_connection" "testing_peering" {
  peer_vpc_id = "${module.management_network.vpc_id}"
  vpc_id = "${aws_vpc.testing_vpc.id}"
  auto_accept = true
}

resource "aws_main_route_table_association" "testing" {
  vpc_id = "${aws_vpc.testing_vpc.id}"
  route_table_id = "${aws_default_route_table.testing.id}"
}


resource "aws_route" "testing_ig" {
  route_table_id = "${aws_default_route_table.testing.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.testing.id}"

}

resource "aws_route" "public_route" {
  route_table_id = "${aws_default_route_table.testing.id}"
  destination_cidr_block = "${element(var.vpc_cidr_list, 0)}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.testing_peering.id}"
}

resource "aws_route" "testing_to_default" {
  route_table_id = "${module.management_network.default_rt_id}"
  destination_cidr_block = "${element(var.vpc_cidr_list, 3)}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.testing_peering.id}"
}

resource "aws_route" "testing_to_default_private" {
  route_table_id = "${module.management_network.private_rt_id}"
  destination_cidr_block = "${element(var.vpc_cidr_list, 3)}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.testing_peering.id}"
}

resource "cloudflare_record" "jumphost_record" {
  domain = "twindb.com"
  name = "jumphost"
  type = "A"
  value = "${module.management_app.public_jumhost_ip}"
}

# User for CI of chef repo

resource "aws_iam_user" "chef_kitchen" {
    name = "chef-kitchen"
}

resource "aws_iam_access_key" "chef_kitchen_key" {
    user = "${aws_iam_user.chef_kitchen.name}"
}

resource "aws_iam_user_policy" "chef_kitchen_policy" {
    user = "${aws_iam_user.chef_kitchen.name}"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:Describe*",
                "ec2:GetConsole*"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeInstances", "ec2:DescribeImages",
                "ec2:DescribeKeyPairs", "ec2:DescribeSecurityGroups",
                "ec2:DescribeAvailabilityZones",
                "ec2:RunInstances", "ec2:TerminateInstances",
                "ec2:StopInstances", "ec2:StartInstances",
                "ec2:CreateTags", "ec2:DescribeTags", "ec2:DeleteTags"
            ],
            "Resource": [
                "arn:aws:ec2:*:*:subnet/${aws_subnet.testing_vpc_subnet.id}",
                "arn:aws:ec2:*:*:network-interface/*",
                "arn:aws:ec2:*:*:instance/*",
                "arn:aws:ec2:*:*:volume/*",
                "arn:aws:ec2:*::image/ami-*",
                "arn:aws:ec2:*:*:key-pair/*",
                "arn:aws:ec2:*:*:security-group/*"
            ]
        }
    ]
}
EOF
}


# User for CI of twindb-backup tool
resource "aws_iam_user" "twindb_backup_ci" {
    name = "twindb-backup"
}

resource "aws_iam_access_key" "twindb_backup_ci_key" {
    user = "${aws_iam_user.twindb_backup_ci.name}"
}

resource "aws_iam_user_policy" "twindb_backup_ci" {
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": "*"
        }
    ]
}
EOF
    user = "${aws_iam_user.twindb_backup_ci.name}"
}


# Admin users
resource "aws_iam_user" "maksym_kryva" {
    name = "maksym.kryva"
}

resource "aws_iam_access_key" "maskym_kryva_key" {
    user = "${aws_iam_user.maksym_kryva.name}"
}

resource "aws_iam_user" "aleks" {
    name = "aleks"
}

resource "aws_iam_access_key" "aleks_key" {
    user = "${aws_iam_user.aleks.name}"

}

resource "aws_iam_user_policy_attachment" "maksym_kryva_policy" {
    user       = "${aws_iam_user.maksym_kryva.name}"
    policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
resource "aws_iam_user_policy_attachment" "aleks_policy" {
    user       = "${aws_iam_user.aleks.name}"
    policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_user" "terraform_ci_user" {
    name = "terraform"
}

resource "aws_iam_user_policy_attachment" "terraform_policy" {
    user       = "${aws_iam_user.terraform_ci_user.name}"
    policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}


resource "aws_iam_access_key" "terraform_ci_user" {
    user = "${aws_iam_user.terraform_ci_user.name}"

}
