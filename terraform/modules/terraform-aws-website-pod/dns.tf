resource "aws_route53_record" "combined" {
  count   = length(var.dns_a_records)
  zone_id = data.aws_route53_zone.website.id
  name    = var.dns_a_records[count.index]
  type    = "A"
  alias {
    name                   = aws_alb.website.dns_name
    zone_id                = aws_alb.website.zone_id
    evaluate_target_health = true
  }
}

