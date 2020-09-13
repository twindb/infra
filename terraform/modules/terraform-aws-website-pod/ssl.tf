resource "aws_acm_certificate" "website" {
  count       = var.issue_certificate ? 1 : 0
  domain_name = length(var.dns_a_records[0]) > 0 ? "${var.dns_a_records[0]}.${var.dns_zone}" : var.dns_zone
  subject_alternative_names = [
    for record in slice(var.dns_a_records, 1, length(var.dns_a_records)) : "${record}.${var.dns_zone}"
  ]
  validation_method = "DNS"

  tags = local.common_tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_validation" {
  count   = var.issue_certificate ? length(var.dns_a_records) : 0
  name    = aws_acm_certificate.website[0].domain_validation_options[count.index].resource_record_name
  type    = aws_acm_certificate.website[0].domain_validation_options[count.index].resource_record_type
  zone_id = data.aws_route53_zone.website.id
  records = [
    aws_acm_certificate.website[0].domain_validation_options[count.index].resource_record_value
  ]
  ttl = 60
}

resource "aws_acm_certificate_validation" "website" {
  count                   = var.issue_certificate ? 1 : 0
  certificate_arn         = aws_acm_certificate.website[0].arn
  validation_record_fqdns = aws_route53_record.cert_validation.*.fqdn
}
