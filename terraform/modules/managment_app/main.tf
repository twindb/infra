resource "aws_instance" "jumphost" {
    ami = "${var.ami}"
    instance_type = "${var.instance_type}"
    subnet_id = "${var.subnet_id}"
    associate_public_ip_address = true
    vpc_security_group_ids = [
    "${var.sg_id}"]
    key_name = "${aws_key_pair.main_key_pair.key_name}"
    tags {
        Name = "${var.jumphost_instance_tag}"
    }
    root_block_device = {
        volume_size = "${var.root_volume_size}"
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
  instance = "${aws_instance.jumphost.id}"
  vpc = true
}
resource "aws_eip_association" "jumphost_assoc" {
  instance_id   = "${aws_instance.jumphost.id}"
  allocation_id = "${aws_eip.jumphost_eip.id}"
}

### KEYS ###

resource "aws_key_pair" "main_key_pair" {
  key_name = "${var.main_aws_key_pair_name}"
  public_key = "${var.main_aws_key_pair_public_key}"
}

### USERS ###

resource "aws_iam_user" "backup" {
  name = "backup"
}

resource "aws_iam_access_key" "backup" {
  user = "${aws_iam_user.backup.name}"
}

resource "aws_iam_user_policy" "s3_policy" {
  name = "s3_policy"
  user = "${aws_iam_user.backup.name}"

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
}
