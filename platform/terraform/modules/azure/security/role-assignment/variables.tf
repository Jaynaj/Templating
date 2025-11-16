variable "scope" {
  description = "Scope for the role assignment"
  type        = string
}

variable "role_definition_name" {
  description = "Name of the role definition"
  type        = string
  default     = null
}

variable "role_definition_id" {
  description = "ID of the role definition"
  type        = string
  default     = null
}

variable "principal_id" {
  description = "Principal ID to assign the role to"
  type        = string
}

variable "principal_type" {
  description = "Principal type (User, Group, ServicePrincipal)"
  type        = string
  default     = null
}

variable "skip_service_principal_aad_check" {
  description = "Skip service principal AAD check"
  type        = bool
  default     = false
}
