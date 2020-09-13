data "aws_ami" "centos" {
  most_recent = true
  owners      = ["aws-marketplace"]
  filter {
    name   = "product-code"
    values = ["aw0evgkw8e5c1q413zgy5pjce"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

resource "aws_key_pair" "test" {
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDBOhywtJIt0uXyvK6uFuMOLgMHywrJ/uyYNoXhRmRbc11rLrhJRYNv7LiJFBlduhge1v6w4X+tcdDCDmY1RBbjgheL160cd2ComNsLulL6qVkduSKkiN7pnY1jjXZ9MEwnAZDeKNoPp0gZ1aL2+TKE2HUg6iyN8ASGfcADH3K5fqfxek102cTTuvLIfdZF/NmtxDEE2qZxgQz9PNqTwn4BdpL6QoJztyEie/ebWaxoiiCofDRXNncAKLEq4denAWpm9rsEoJU6LGtZerKQ/7/sGXc2qORMDnHndDC7uBF35VME4mYX9y9/UTaK/F19FSOiQqyQYF8UKj9snZG5zEdEPDovPU8fpZdYcfnYtPqV3f0GZsYj1kWcnWKWd/lbu8fnQtOWA+D92IP9Tf4czjVpcuCPSpK2H3LoStjcoKi/UlJcwP7TT8GnLUC1THspUtMCJnbYLogmtBqeJRatVDrRADjTnof9N+zt2nCjvceu9/nnxzt/hwbGifM4aAtQMtZD2sT+6ip6HDi+JHcLyy5SeUkfS7Ep1VQxTMTnS+CpZijUE7HTV+MWSLpfqf7e/EEc3v2Nx1lX/LNQcFb+ZiNAAeYO15lL/hzy7kXz5QgR/i9oQ9r30pvLz2Vd74qU0pdSTPGBk7sxuJwQqS8addrXOiLbcM1hsXhMRkBUsq/u4w== deployer@"
}

module "lb" {
  source                     = "../../"
  service_name               = "website"
  subnets                    = module.network.subnet_public_ids
  enable_deletion_protection = false
  ami                        = data.aws_ami.centos.id
  backend_subnets            = module.network.subnet_private_ids
  asg_min_size               = 3
  internet_gateway_id        = module.network.internet_gateway_id
  dns_zone                   = "revdb.dev"
  dns_a_records              = ["bogus-test-stuff", "www"]
  issue_certificate          = true
  deployer_key_pair_name     = aws_key_pair.test.key_name
  userdata                   = local.userdata
  secrets_arn_list = [
    "arn:aws:secretsmanager:us-east-1:326244844621:secret:datadog_api_key-r1sC0H",
    "arn:aws:secretsmanager:us-east-1:326244844621:secret:datadog_app_key-LGrpFw"
  ]
  keys_arn_list = [
    "arn:aws:kms:us-east-1:326244844621:key/8da9eccf-87a2-4d90-95e6-ba487adfca66"
  ]
  s3_bucket_rw_list = []
  s3_bucket_ro_list = []

}
