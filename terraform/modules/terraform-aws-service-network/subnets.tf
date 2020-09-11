resource "aws_subnet" "all" {
  for_each                = { for s in var.subnets : s.cidr => s }
  cidr_block              = each.value.cidr
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = each.value.availability-zone
  map_public_ip_on_launch = each.value.map_public_ip_on_launch

  tags = merge(
    var.tags,
    {
      "Name"        = each.key
      "environment" = var.environment
      "service"     = var.service_name
      "management"  = local.is_management_network
    }
  )
}
