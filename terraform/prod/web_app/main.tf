data "aws_vpc" "default_vpc" {
  cidr_block = "${element(var.vpc_cidr_list, 0)}"
  tags {
    Name = "${var.vpc_tags[element(var.vpc_cidr_list, 0)]}"
  }
}

module "web_app_network" {
  source = "../../modules/service_network"
  environment = "production"
  service_name = "web_app"
  vpc_subnets_cidr_blocks = "${var.vpc_web_subnet_cidr_blocks}"
  public_subnet_tag = "${var.web_public_subnet_tag_prod}"
  private_subnet_tag = "${var.web_private_subnet_tag_prod}"
  private_rt_tag = "${var.web_private_rt_prod}"
  default_rt_tag = "${var.web_default_rt_prod}"
  vpc_tags = "${var.vpc_tags}"
  vpc_cidr_block = "${element(var.vpc_cidr_list, 2)}"
}

resource "aws_vpc_peering_connection" "peering" {
  peer_vpc_id = "${data.aws_vpc.default_vpc.id}"
  vpc_id = "${module.web_app_network.vpc_id}"
  auto_accept = true
}

resource "aws_route" "private_routes" {
  route_table_id = "${module.web_app_network.private_rt_id}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.peering.id}"
  destination_cidr_block = "${element(var.vpc_default_subnet_cidr_blocks, count.index)}"
  count = "${length(var.vpc_default_subnet_cidr_blocks)}"
}

resource "aws_route" "public_routes" {
  route_table_id = "${module.web_app_network.default_rt_id}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.peering.id}"
  destination_cidr_block = "${element(var.vpc_default_subnet_cidr_blocks, count.index)}"
  count = "${length(var.vpc_default_subnet_cidr_blocks)}"
}

data "aws_route_table" "default_private_rt" {
  vpc_id = "${data.aws_vpc.default_vpc.id}"
  tags = "${var.default_private_rt_tag}"
}

data "aws_route_table" "default_public_rt" {
  vpc_id = "${data.aws_vpc.default_vpc.id}"
  tags = "${var.default_rt_table_tag}"
}

resource "aws_route" "private_routes_to_default" {
  route_table_id = "${data.aws_route_table.default_private_rt.id}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.peering.id}"
  destination_cidr_block = "${element(var.vpc_cidr_list, 2)}"
}

resource "aws_route" "public_routes_to_default" {
  route_table_id = "${data.aws_route_table.default_public_rt.id}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.peering.id}"
  destination_cidr_block = "${element(var.vpc_cidr_list, 2)}"
}

resource "aws_security_group" "web_app_sg" {
  name = "${var.web_app_sg_name}"
  description = "Security group for a web app. HTTP + HTTPS + ICMP"
  vpc_id = "${module.web_app_network.vpc_id}"

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  egress {
    protocol = -1
    from_port = 0
    to_port = 0
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  tags {
    Name = "${var.web_app_sg_name}"
  }
}

module "web_app" {
    source                           = "../../modules/web_app/"
    web_sg_id                        = "${aws_security_group.web_app_sg.id}"
    web_public_subnet_id             = "${module.web_app_network.public_subnet_id}"
    web_instance_type                = "m4.large"
    ssl_cert_arn                     = "arn:aws:acm:us-east-1:100576059692:certificate/2ccf8b5e-1c57-4c26-bbc1-e0858c0d2a29"
    database_instance_type           = "t2.medium"
    environment                      = "production"
    connection_draining_timeout      = 60
    elb_name                         = "twindb"
    key_name                         = "deployer"
    web_subnet_id                    = "${module.web_app_network.private_subnet_id}"
    idle_timeout                     = 60
    website_database_bucket          = "twindb-website-database"
    website_upload_bucket            = "twindb-website-uploads"
    website_uploads_s3_tags          = "${var.website_uploads_s3_tags}"
    website_database_s3_uploads_tags = "${var.website_database_s3_uploads_tags}"
    ami                              = "ami-46c1b650"
    count                            = 1
    health_check_target              = "HTTP:8080/"
}

resource "cloudflare_record" "twindb" {
  domain = "twindb.com"
  name = "twindb.com"
  type = "CNAME"
  value = "${module.web_app.elb_dns_name}"
}

resource "cloudflare_record" "www" {
  domain = "twindb.com"
  name = "wwww"
  type = "CNAME"
  value = "${cloudflare_record.twindb.name}"
}

# User for website (no backups!)

resource "aws_iam_user" "web_app" {
    name = "website"
}

resource "aws_iam_access_key" "web_app" {
    user = "${aws_iam_user.web_app.name}"
}

resource "aws_iam_user_policy" "website_policy" {
    user = "${aws_iam_user.web_app.name}"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
          "Effect": "Allow",
          "Action": ["s3:ListBucket"],
          "Resource": [
            "arn:aws:s3:::twindb-website-uploads",
            "arn:aws:s3:::twindb-website-uploads-staging",
            "arn:aws:s3:::twindb-website-database"
          ]
        },
        {
          "Effect": "Allow",
          "Action": [
            "s3:PutObject",
            "s3:GetObject",
            "s3:DeleteObject"
          ],
          "Resource": [
            "arn:aws:s3:::twindb-website-uploads/*",
            "arn:aws:s3:::twindb-website-uploads-staging/*",
            "arn:aws:s3:::twindb-website-database/*"
          ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:Describe*",
                "ec2:GetConsole*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}
