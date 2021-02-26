module "twindb_com" {
  source                 = "./../modules/terraform-aws-website-pod"
  ami                    = "ami-0074ee617a234808d"
  backend_subnets        = module.management_network.subnet_private_ids
  deployer_key_pair_name = aws_key_pair.keypairs["deployer"].key_name
  dns_zone               = aws_route53_zone.twindb_com.name
  internet_gateway_id    = module.management_network.internet_gateway_id
  keys_arn_list          = []
  s3_bucket_ro_list      = []
  s3_bucket_rw_list      = []
  secrets_arn_list = [
    aws_secretsmanager_secret.rds_credentials.arn
  ]
  service_name         = "website"
  subnets              = module.management_network.subnet_public_ids
  userdata             = data.template_cloudinit_config.webserver_init.rendered
  asg_max_size         = 1
  asg_min_size         = 1
  alb_healthcheck_path = "/"
}
