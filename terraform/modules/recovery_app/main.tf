resource "aws_instance" "recovery" {
  # CentOS 7
  # https://aws.amazon.com/marketplace/pp/B00O7WM7QW
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  subnet_id = "${var.recovery_subnet_id}"
  vpc_security_group_ids = [
    "${var.recovery_sg_id}"]
  key_name = "${var.key_name}"

  ebs_block_device {
    device_name = "/dev/sdb"
    volume_type = "gp2"
    volume_size = "${var.volume_size}"
    delete_on_termination = true
  }

  tags {
    Name = "recovery_${var.environment}_${count.index}"
  }
  count = "${var.instance_count}"

}

resource "aws_elb" "twindb_recovery_https_elb" {

  name = "${var.elb_name}"
  security_groups = ["${var.recovery_sg_id}"]
  subnets = ["${var.recovery_public_subnet_id}"]

  "listener" {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 443
    lb_protocol = "https"
    ssl_certificate_id = "${var.ssl_cert_arn}"
  }

  "listener" {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold   = 10
    unhealthy_threshold = 2
    timeout             = 5
    target              = "${var.health_check_target}"
    interval            = 30
  }

  instances                   = [
    "${aws_instance.recovery.*.id}"
  ]
  cross_zone_load_balancing   = true
  idle_timeout                = "${var.idle_timeout}"
  connection_draining         = true
  connection_draining_timeout = "${var.connection_draining_timeout}"

  tags {
    Name = "${var.environment}_twindb-recovery-https-elb"
  }
}

resource "aws_load_balancer_policy" "elb_policy" {
  load_balancer_name = "${var.elb_name}"
  policy_name = "${var.elb_policy_name}"
  policy_type_name = "SSLNegotiationPolicyType"

  policy_attribute = {
    name  = "ECDHE-RSA-AES128-GCM-SHA256"
    value = "true"
  }

  policy_attribute = {
    name  = "Protocol-TLSv1.2"
    value = "true"
  }
}

resource "aws_lb_cookie_stickiness_policy" "www_80_recovery" {
  name                     = "${var.environment}-www80-recovery"
  load_balancer            = "${aws_elb.twindb_recovery_https_elb.id}"
  lb_port                  = 80
  cookie_expiration_period = 600
}

resource "aws_lb_cookie_stickiness_policy" "www_443_recovery" {
  name                     = "${var.environment}-www443-recovery"
  load_balancer            = "${aws_elb.twindb_recovery_https_elb.id}"
  lb_port                  = 443
  cookie_expiration_period = 600
}

resource "aws_load_balancer_listener_policy" "twindb-listener-policies-443" {
  load_balancer_name = "${var.elb_name}"
  load_balancer_port = 443
  policy_names = [
    "${var.elb_policy_name}",
    "${aws_lb_cookie_stickiness_policy.www_443_recovery.name}"
  ]
}
