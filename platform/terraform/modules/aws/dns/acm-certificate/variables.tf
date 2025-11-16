variable "domain_name" {
  description = "Domain name for the certificate"
  type        = string
}

variable "subject_alternative_names" {
  description = "Subject alternative names for the certificate"
  type        = list(string)
  default     = []
}

variable "validation_method" {
  description = "Validation method (DNS or EMAIL)"
  type        = string
  default     = "DNS"
}

variable "key_algorithm" {
  description = "Algorithm for the certificate key (RSA_2048, RSA_4096, EC_prime256v1, EC_secp384r1)"
  type        = string
  default     = "RSA_2048"
}

variable "certificate_transparency_logging_preference" {
  description = "Certificate transparency logging preference (ENABLED or DISABLED)"
  type        = string
  default     = "ENABLED"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
