//data "aws_vpc" "default_vpc" {
//  cidr_block = "${element(var.vpc_cidr_list, 0)}"
//  tags {
//    Name = "${var.vpc_tags[element(var.vpc_cidr_list, 0)]}"
//  }
//}

//data "aws_route_table" "default_private_rt" {
//    vpc_id = "${data.aws_vpc.default_vpc.id}"
//    tags = "${var.default_private_rt_tag}"
//}
//
//data "aws_route_table" "default_public_rt" {
//    vpc_id = "${data.aws_vpc.default_vpc.id}"
//    tags = "${var.default_rt_table_tag}"
//}

// Archive
resource "aws_s3_bucket" "website_database_archive" {
    bucket = "twindb-website-database-staging-archive"
    region = "us-east-1"
    tags {
        Name = "${var.environment} ${var.service_name} database backups"
    }
}

resource "aws_s3_bucket" "website_uploads_archive" {
    bucket = "twindb-website-uploads-staging-archive"
    region = "us-east-1"
    tags {
        Name = "${var.environment} ${var.service_name} media files"
    }
}

module "web_app_network" {
    source                = "./../../modules/service_network_3"
    service_name          = "${var.service_name}"
    environment           = "${var.environment}"

    vpc_cidr_block        = "${var.vpc_cidr_block}"
    private_subnet_cidr   = "${var.private_subnet_cidr}"
    public_subnet_cidr    = "${var.public_subnet_cidr}"

    management_cidr_block = "${var.management_cidr_block}"
}


module "database" {
    source            = "./../../modules/database"
    subnet_id         = "${module.web_app_network.private_subnet_id}"
    security_group_id = "${module.web_app_network.default_security_group_id}"
    key_name          = "${var.key_name}"
    public_subnet_id  = "${module.web_app_network.public_subnet_id}"
    dependencies = [
        "${module.web_app_network.depended_on}"
    ]
}

//
//resource "aws_security_group" "web_app_sg" {
//  name = "${var.web_app_sg_name}"
//  description = "Security group for a web app. HTTP + HTTPS + ICMP"
//  vpc_id = "${module.web_app_network.vpc_id}"
//
//  ingress {
//    from_port = 0
//    to_port = 0
//    protocol = "-1"
//    cidr_blocks = [
//      "0.0.0.0/0"
//    ]
//  }
//
//  egress {
//    protocol = -1
//    from_port = 0
//    to_port = 0
//    cidr_blocks = [
//      "0.0.0.0/0"]
//  }
//
//  tags {
//    Name = "${var.web_app_sg_name}"
//  }
//}
//
//module "web_app" {
//  source = "./../../modules/web_app"
//  web_sg_id = "${aws_security_group.web_app_sg.id}"
//  web_public_subnet_id = "${module.web_app_network.public_subnet_id}"
//  web_instance_type = "t2.large"
//  ssl_cert_arn = "arn:aws:acm:us-east-1:100576059692:certificate/2ccf8b5e-1c57-4c26-bbc1-e0858c0d2a29"
//  database_instance_type = "t2.medium"
//  environment = "staging"
//  connection_draining_timeout = "60"
//  elb_name = "twindb-staging"
//  key_name = "deployer"
//  web_subnet_id = "${module.web_app_network.private_subnet_id}"
//  idle_timeout = "60"
//  website_database_bucket = "twindb-website-database-staging"
//  website_upload_bucket = "twindb-website-uploads-staging"
//  ami = "ami-4bf3d731"
//  website_uploads_s3_tags = "${var.website_uploads_s3_tags}"
//  website_database_s3_uploads_tags = "${var.website_database_s3_uploads_tags}"
//  count = 0
//}
//
//resource "cloudflare_record" "twindb" {
//  domain = "twindb.com"
//  name = "staging"
//  type = "CNAME"
//  value = "${module.web_app.elb_dns_name}"
//  proxied = true
//}
