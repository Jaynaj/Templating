resource "aws_lb_listener" "this" {
  load_balancer_arn = var.load_balancer_arn
  port              = var.port
  protocol          = var.protocol
  ssl_policy        = var.protocol == "HTTPS" ? var.ssl_policy : null
  certificate_arn   = var.protocol == "HTTPS" ? var.certificate_arn : null
  alpn_policy       = var.alpn_policy

  default_action {
    type             = var.default_action_type
    target_group_arn = var.default_action_type == "forward" ? var.target_group_arn : null

    dynamic "redirect" {
      for_each = var.default_action_type == "redirect" && var.redirect_config != null ? [var.redirect_config] : []
      content {
        port        = lookup(redirect.value, "port", "#{port}")
        protocol    = lookup(redirect.value, "protocol", "#{protocol}")
        status_code = redirect.value.status_code
        host        = lookup(redirect.value, "host", "#{host}")
        path        = lookup(redirect.value, "path", "/#{path}")
        query       = lookup(redirect.value, "query", "#{query}")
      }
    }

    dynamic "fixed_response" {
      for_each = var.default_action_type == "fixed-response" && var.fixed_response_config != null ? [var.fixed_response_config] : []
      content {
        content_type = fixed_response.value.content_type
        message_body = lookup(fixed_response.value, "message_body", null)
        status_code  = lookup(fixed_response.value, "status_code", "200")
      }
    }
  }

  tags = var.tags
}

resource "aws_lb_listener_certificate" "this" {
  for_each = toset(var.additional_certificate_arns)

  listener_arn    = aws_lb_listener.this.arn
  certificate_arn = each.value
}
