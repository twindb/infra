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
}
