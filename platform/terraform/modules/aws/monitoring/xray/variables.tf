variable "name" {
  description = "Name of the X-Ray sampling rule"
  type        = string
}

variable "sampling_rules" {
  description = "List of X-Ray sampling rules"
  type = list(object({
    rule_name      = string
    priority       = number
    version        = optional(number)
    reservoir_size = number
    fixed_rate     = number
    url_path       = string
    host           = string
    http_method    = string
    service_type   = string
    service_name   = string
    resource_arn   = string
    attributes     = optional(map(string))
  }))
  default = []
}

variable "enable_encryption" {
  description = "Enable encryption for X-Ray"
  type        = bool
  default     = true
}

variable "encryption_type" {
  description = "Encryption type (NONE or KMS)"
  type        = string
  default     = "KMS"
}

variable "kms_key_id" {
  description = "KMS key ID for encryption"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
