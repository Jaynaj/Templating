resource "aws_lb_target_group" "this" {
  name        = var.name
  port        = var.port
  protocol    = var.protocol
  vpc_id      = var.vpc_id
  target_type = var.target_type

  deregistration_delay          = var.deregistration_delay
  slow_start                    = var.slow_start
  load_balancing_algorithm_type = var.load_balancing_algorithm_type
  preserve_client_ip            = var.preserve_client_ip
  proxy_protocol_v2             = var.proxy_protocol_v2
  lambda_multi_value_headers_enabled = var.lambda_multi_value_headers_enabled

  health_check {
    enabled             = lookup(var.health_check, "enabled", true)
    interval            = lookup(var.health_check, "interval", 30)
    path                = lookup(var.health_check, "path", "/")
    port                = lookup(var.health_check, "port", "traffic-port")
    protocol            = lookup(var.health_check, "protocol", var.protocol)
    timeout             = lookup(var.health_check, "timeout", 5)
    healthy_threshold   = lookup(var.health_check, "healthy_threshold", 3)
    unhealthy_threshold = lookup(var.health_check, "unhealthy_threshold", 3)
    matcher             = lookup(var.health_check, "matcher", "200")
  }

  dynamic "stickiness" {
    for_each = var.stickiness != null ? [var.stickiness] : []
    content {
      enabled         = stickiness.value.enabled
      type            = stickiness.value.type
      cookie_duration = lookup(stickiness.value, "cookie_duration", 86400)
      cookie_name     = lookup(stickiness.value, "cookie_name", null)
    }
  }

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}
