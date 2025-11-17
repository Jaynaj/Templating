variable "name" {
  description = "Name of the volume"
  type        = string
}

variable "size" {
  description = "Size of the volume in GB"
  type        = number
}

variable "location" {
  description = "Location (nbg1, fsn1, hel1, ash, hil)"
  type        = string
  default     = null
}

variable "server_id" {
  description = "Server ID to attach the volume to"
  type        = number
  default     = null
}

variable "automount" {
  description = "Enable automount"
  type        = bool
  default     = false
}

variable "format" {
  description = "Format the volume (xfs or ext4)"
  type        = string
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
