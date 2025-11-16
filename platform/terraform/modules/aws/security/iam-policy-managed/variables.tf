variable "name" {
  description = "Name of the IAM policy"
  type        = string
}

variable "description" {
  description = "Description of the IAM policy"
  type        = string
  default     = ""
}

variable "policy" {
  description = "IAM policy document (JSON)"
  type        = string
}

variable "path" {
  description = "Path for the IAM policy"
  type        = string
  default     = "/"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
