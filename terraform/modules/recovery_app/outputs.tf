output "elb_dns_record" {
  value = "${aws_elb.twindb_recovery_https_elb.dns_name}"
}