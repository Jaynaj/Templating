variable "name" {
  description = "Name of the secret"
  type        = string
}

variable "description" {
  description = "Description of the secret"
  type        = string
  default     = ""
}

variable "secret_string" {
  description = "Secret string value"
  type        = string
  default     = null
  sensitive   = true
}

variable "secret_binary" {
  description = "Secret binary value (base64 encoded)"
  type        = string
  default     = null
  sensitive   = true
}

variable "kms_key_id" {
  description = "KMS key ID for encryption"
  type        = string
  default     = null
}

variable "recovery_window_in_days" {
  description = "Recovery window in days for deleted secrets"
  type        = number
  default     = 30
}

variable "rotation_enabled" {
  description = "Enable automatic rotation"
  type        = bool
  default     = false
}

variable "rotation_lambda_arn" {
  description = "Lambda function ARN for rotation"
  type        = string
  default     = null
}

variable "rotation_rules" {
  description = "Rotation rules configuration"
  type = object({
    automatically_after_days = number
  })
  default = null
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
