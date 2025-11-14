variable "load_balancer_arn" {
  description = "ARN of the load balancer"
  type        = string
}

variable "port" {
  description = "Port for the listener"
  type        = number
}

variable "protocol" {
  description = "Protocol (HTTP, HTTPS, TCP, TLS, UDP, TCP_UDP)"
  type        = string
}

variable "ssl_policy" {
  description = "SSL policy for HTTPS/TLS listeners"
  type        = string
  default     = "ELBSecurityPolicy-TLS-1-2-2017-01"
}

variable "certificate_arn" {
  description = "ARN of the default SSL certificate"
  type        = string
  default     = null
}

variable "alpn_policy" {
  description = "ALPN policy for TLS listeners"
  type        = string
  default     = null
}

variable "default_action_type" {
  description = "Type of default action (forward, redirect, fixed-response)"
  type        = string
  default     = "forward"
}

variable "target_group_arn" {
  description = "ARN of the target group for forward action"
  type        = string
  default     = null
}

variable "redirect_config" {
  description = "Redirect configuration"
  type        = any
  default     = null
}

variable "fixed_response_config" {
  description = "Fixed response configuration"
  type        = any
  default     = null
}

variable "additional_certificate_arns" {
  description = "Additional SSL certificate ARNs"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
