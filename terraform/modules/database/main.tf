resource "aws_instance" "database" {
    ami = "${var.ami}"
    instance_type = "${var.instance_type}"
    subnet_id = "${var.subnet_id}"
    vpc_security_group_ids = [
        "${var.security_group_id}"
    ]
    key_name = "${var.key_name}"

    ebs_block_device {
        device_name           = "/dev/sdb"
        volume_type           = "${var.data_volume_type}"
        volume_size           = "${var.data_volume_size}"
        delete_on_termination = true
    }

    root_block_device {
        volume_type           = "${var.root_volume_type}"
        volume_size           = "${var.root_volume_size}"
        delete_on_termination = true
    }

    tags {
        Name        = "database"
        Environment = "${var.environment}"
    }
    provisioner "chef" {
        version         = "14.12.9"
        node_name       = "${self.private_dns}"
        recreate_client = true
        server_url      = "https://api.chef.io/organizations/twindb"
        run_list        = [
            "role[website_master]"
        ]
        user_key        = "${file("../../../.env/${var.chef_user}.pem")}"
        secret_key      = "${file("../../../.env/encrypted_data_bag_secret")}"
        user_name       = "${var.chef_user}"
        connection {
            host                = "${self.private_ip}"
            user                = "${var.ssh_username}"
            private_key         = "${file("../../../.env/deployer.key")}"
            bastion_host        = "jumphost.twindb.com"
            bastion_private_key = "${file("../../../.env/deployer.key")}"
            bastion_port        = 22
            bastion_user        = "${var.ssh_username}"
        }
    }
    depends_on = [
        "null_resource.dependency_getter",
    ]
}
