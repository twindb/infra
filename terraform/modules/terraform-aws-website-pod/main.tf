resource "aws_alb" "website" {
  name                       = "website-load-balancer"
  enable_deletion_protection = var.enable_deletion_protection

  tags = merge(
    local.common_tags
  )
  subnets = var.subnets
}

resource "aws_alb_listener" "redirect_to_ssl" {
  load_balancer_arn = aws_alb.website.arn
  port              = 80
  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "ssl" {
  count             = var.issue_certificate ? 1 : 0
  load_balancer_arn = aws_alb.website.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = ""
  certificate_arn   = aws_acm_certificate.website[count.index].arn
  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.website.arn
  }
}

resource "aws_alb_target_group" "website" {
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = data.aws_subnet.selected.vpc_id

  health_check {
    path                = var.alb_healthcheck_path
    port                = var.alb_healthcheck_port
    protocol            = var.alb_healthcheck_protocol
    healthy_threshold   = var.alb_healthcheck_healthy_threshold
    unhealthy_threshold = var.alb_healthcheck_uhealthy_threshold
    interval            = var.alb_healthcheck_interval
    timeout             = var.alb_healthcheck_timeout
    matcher             = var.alb_healthcheck_response_code_matcher
  }

}

resource "aws_autoscaling_group" "website" {
  name                      = "website_asg_${aws_launch_configuration.website.name}"
  launch_configuration      = aws_launch_configuration.website.name
  min_size                  = var.asg_min_size
  max_size                  = var.asg_max_size
  min_elb_capacity          = var.asg_min_size
  vpc_zone_identifier       = var.backend_subnets
  health_check_type         = var.health_check_type
  wait_for_capacity_timeout = var.wait_for_capacity_timeout
  max_instance_lifetime     = var.max_instance_lifetime_days * 24 * 3600
  target_group_arns = [
    aws_alb_target_group.website.arn
  ]
  tag {
    key                 = "Name"
    value               = "webserver"
    propagate_at_launch = true
  }
  tag {
    key                 = "environment"
    value               = var.environment
    propagate_at_launch = true
  }
  tag {
    key                 = "service"
    value               = var.service_name
    propagate_at_launch = true
  }
  tag {
    key                 = "managed-by"
    value               = "terraform"
    propagate_at_launch = true
  }
  tag {
    key                 = "account"
    value               = data.aws_caller_identity.current.account_id
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "website" {
  name_prefix          = "web-"
  image_id             = var.ami
  instance_type        = var.instance_type
  user_data            = var.userdata
  key_name             = var.deployer_key_pair_name
  iam_instance_profile = aws_iam_instance_profile.revdb_webserver_profile.name

  root_block_device {
    volume_size           = var.root_volume_size
    delete_on_termination = true
  }
  lifecycle {
    create_before_destroy = true
  }
}
