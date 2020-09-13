resource "aws_db_subnet_group" "rdsmain_private" {
  name        = "rdsmain-private"
  description = "Private subnets for RDS instance"

  # Comma sep. list of subnet ids from the VPC
  subnet_ids = module.management_network.subnet_private_ids
}

resource "aws_secretsmanager_secret" "rds_credentials" {
  name                    = var.rds_credentials_secret_name
  description             = "Credentials to connect to website database"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "current" {
  secret_id = aws_secretsmanager_secret.rds_credentials.arn
  secret_string = jsonencode(
    {
      username : var.rds_username,
      password : var.rds_password,
      hostname : aws_db_instance.wordpress_db.address
      port : aws_db_instance.wordpress_db.port
      database : var.rds_database
    }
  )
}

resource "aws_db_instance" "wordpress_db" {
  storage_type                = "gp2"
  engine                      = "mysql"
  engine_version              = "8.0"
  instance_class              = "db.t3.small"
  name                        = var.rds_database
  username                    = var.rds_username
  password                    = var.rds_password
  allocated_storage           = 30
  allow_major_version_upgrade = false
  auto_minor_version_upgrade  = true
  backup_retention_period     = 7
  backup_window               = "09:46-10:16"
  maintenance_window          = "Mon:00:00-Mon:03:00"
  deletion_protection         = false
  db_subnet_group_name        = aws_db_subnet_group.rdsmain_private.name
  skip_final_snapshot         = true
  multi_az                    = true
}
