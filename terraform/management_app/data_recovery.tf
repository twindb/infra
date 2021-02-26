resource "aws_instance" "db" {
  ami           = data.aws_ami.ubuntu_bionic.id
  instance_type = "t3.micro"
  subnet_id     = module.management_network.subnet_public_ids[0]
  key_name      = aws_key_pair.keypairs["deployer"].key_name
  tags = {
    Name = "db"
  }
  user_data = data.template_cloudinit_config.db.rendered
}

resource "aws_instance" "recovery" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.xlarge"
  subnet_id     = module.management_network.subnet_public_ids[0]
  key_name      = aws_key_pair.keypairs["deployer"].key_name
  tags = {
    Name = "recovery"
  }
  user_data = data.template_cloudinit_config.recovery.rendered
  root_block_device {
    volume_size = "64"
  }
}

resource "aws_route53_record" "db" {
  name    = "db"
  type    = "A"
  zone_id = aws_route53_zone.twindb_com.id
  ttl     = 10
  records = [
    aws_instance.db.public_ip
  ]
}

resource "aws_route53_record" "recovery" {
  name    = "recovery"
  type    = "A"
  zone_id = aws_route53_zone.twindb_com.id
  ttl     = 10
  records = [
    aws_instance.recovery.public_ip
  ]
}
