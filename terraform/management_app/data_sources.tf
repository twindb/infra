data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "template_cloudinit_config" "webserver_init" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = local.userdata
  }
}
