variable "name" {
  description = "Name of the target group"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "port" {
  description = "Port for the target group"
  type        = number
}

variable "protocol" {
  description = "Protocol (HTTP, HTTPS, TCP, TLS, UDP, TCP_UDP)"
  type        = string
}

variable "target_type" {
  description = "Type of target (instance, ip, lambda, alb)"
  type        = string
  default     = "instance"
}

variable "deregistration_delay" {
  description = "Deregistration delay in seconds"
  type        = number
  default     = 300
}

variable "slow_start" {
  description = "Slow start duration in seconds"
  type        = number
  default     = 0
}

variable "load_balancing_algorithm_type" {
  description = "Load balancing algorithm (round_robin or least_outstanding_requests)"
  type        = string
  default     = "round_robin"
}

variable "health_check" {
  description = "Health check configuration"
  type = object({
    enabled             = optional(bool)
    interval            = optional(number)
    path                = optional(string)
    port                = optional(string)
    protocol            = optional(string)
    timeout             = optional(number)
    healthy_threshold   = optional(number)
    unhealthy_threshold = optional(number)
    matcher             = optional(string)
  })
  default = {}
}

variable "stickiness" {
  description = "Stickiness configuration"
  type = object({
    enabled         = bool
    type            = string
    cookie_duration = optional(number)
    cookie_name     = optional(string)
  })
  default = null
}

variable "preserve_client_ip" {
  description = "Preserve client IP address"
  type        = string
  default     = null
}

variable "proxy_protocol_v2" {
  description = "Enable proxy protocol v2"
  type        = bool
  default     = false
}

variable "lambda_multi_value_headers_enabled" {
  description = "Enable multi-value headers for Lambda targets"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
