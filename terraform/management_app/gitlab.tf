resource "cloudflare_record" "gitlab_record" {
    domain = "twindb.com"
    name = "gitlab"
    type = "A"
    value = "${module.gitlab_master.public_gitlab_ip}"
}


module "gitlab_master" {
    source = "../modules/gitlab/"
    aws_region = "${var.aws_region}"
    vpc_id = "${module.management_network.vpc_id}"
    subnet_id = "${module.management_network.public_subnet_id}"
    ami = "ami-0273df992a343e0d6"
    aws_key_pair_name = "deployer"
    name_instance_tag = "gitlab-master"
}
