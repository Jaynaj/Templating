variable "server_id" {
  description = "Server ID to create snapshot from"
  type        = number
}

variable "description" {
  description = "Description of the snapshot"
  type        = string
  default     = null
}

variable "labels" {
  description = "Labels"
  type        = map(string)
  default     = {}
}
