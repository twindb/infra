resource "aws_route53_zone" "twindb_com" {
  name = "twindb.com"
}

resource "aws_route53_record" "mx" {
  name    = ""
  type    = "MX"
  zone_id = aws_route53_zone.twindb_com.id
  records = [
    "1 aspmx.l.google.com",
    "5 alt1.aspmx.l.google.com",
    "5 alt2.aspmx.l.google.com",
    "10 alt3.aspmx.l.google.com",
    "10 alt4.aspmx.l.google.com",
  ]
  ttl = 3600
}

resource "aws_route53_record" "keybase" {
  name    = ""
  type    = "TXT"
  zone_id = aws_route53_zone.twindb_com.id
  ttl     = 3600
  records = [
    "keybase-site-verification=uSIV_E3WHxEKtnGNEQvjvMB7LsAhzJU9zqHDZGzKKrc"
  ]
}
