resource "aws_instance" "gitlab" {
    ami = "${var.ami}"
    instance_type = "${var.instance_type}"
    subnet_id = "${var.subnet_id}"
    associate_public_ip_address = true
    vpc_security_group_ids = [
        "${aws_security_group.gitlab_sg.id}"
    ]
    key_name = "${var.aws_key_pair_name}"
    tags {
        Name = "${var.name_instance_tag}"
    }
    root_block_device = {
        volume_size = "${var.root_volume_size}"
    }

    provisioner "chef" {
        version = "14.12.9"
        node_name = "gitlab"
        recreate_client = true
        server_url = "https://api.chef.io/organizations/twindb"
        run_list = [
            "role[gitlab_master]"
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

resource "aws_eip" "gitlab_eip" {
  instance = "${aws_instance.gitlab.id}"
  vpc = true
}
resource "aws_eip_association" "gitlab_assoc" {
  instance_id   = "${aws_instance.gitlab.id}"
  allocation_id = "${aws_eip.gitlab_eip.id}"
}
