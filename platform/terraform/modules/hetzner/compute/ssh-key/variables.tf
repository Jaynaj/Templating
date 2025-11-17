variable "name" {
  description = "Name of the SSH key"
  type        = string
}

variable "public_key" {
  description = "Public SSH key"
  type        = string
}

variable "labels" {
  description = "Labels"
  type        = map(string)
  default     = {}
}
