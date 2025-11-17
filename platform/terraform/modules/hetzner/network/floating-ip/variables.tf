variable "type" {
  description = "Type of Floating IP (ipv4 or ipv6)"
  type        = string
}

variable "name" {
  description = "Name of the Floating IP"
  type        = string
  default     = null
}

variable "description" {
  description = "Description of the Floating IP"
  type        = string
  default     = null
}

variable "home_location" {
  description = "Home location (nbg1, fsn1, hel1, ash, hil)"
  type        = string
  default     = null
}

variable "server_id" {
  description = "Server ID to assign the Floating IP to"
  type        = number
  default     = null
}

variable "labels" {
  description = "Labels"
  type        = map(string)
  default     = {}
}

variable "delete_protection" {
  description = "Enable delete protection"
  type        = bool
  default     = false
}
