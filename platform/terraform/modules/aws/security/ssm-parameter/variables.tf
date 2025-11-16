variable "name" {
  description = "Name of the SSM parameter"
  type        = string
}

variable "description" {
  description = "Description of the parameter"
  type        = string
  default     = ""
}

variable "type" {
  description = "Type of parameter (String, StringList, or SecureString)"
  type        = string
  default     = "SecureString"
}

variable "value" {
  description = "Value of the parameter"
  type        = string
  sensitive   = true
}

variable "tier" {
  description = "Parameter tier (Standard, Advanced, Intelligent-Tiering)"
  type        = string
  default     = "Standard"
}

variable "key_id" {
  description = "KMS key ID for SecureString encryption"
  type        = string
  default     = null
}

variable "allowed_pattern" {
  description = "Regex pattern for parameter validation"
  type        = string
  default     = null
}

variable "data_type" {
  description = "Data type of the parameter"
  type        = string
  default     = "text"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
