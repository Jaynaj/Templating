# ALB Listener Module

Creates AWS Application Load Balancer listeners with support for HTTP/HTTPS and various routing actions.

## Usage

```hcl
module "https_listener" {
  source = "../../modules/aws/load-balancing/alb-listener"

  load_balancer_arn = module.alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = module.acm_cert.arn

  default_action_type = "forward"
  target_group_arn    = module.target_group.arn

  tags = {
    Environment = "production"
  }
}
```
