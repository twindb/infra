resource "aws_efs_file_system" "uploads" {
}

resource "aws_efs_mount_target" "website" {
  count = length(module.management_network.subnet_private_ids)

  file_system_id = aws_efs_file_system.uploads.id
  subnet_id      = module.management_network.subnet_private_ids[count.index]

  security_groups = [
    aws_security_group.efs.id,
  ]
}

resource "aws_security_group" "efs" {
  name        = "website-efs"
  description = "Allows NFS traffic from instances within the VPC."
  vpc_id      = module.management_network.vpc_id

  ingress {
    from_port = 2049
    to_port   = 2049
    protocol  = "tcp"

    cidr_blocks = [
      module.management_network.vpc_cidr_block,
    ]
  }

  egress {
    from_port = 2049
    to_port   = 2049
    protocol  = "tcp"

    cidr_blocks = [
      module.management_network.vpc_cidr_block,
    ]
  }
}
