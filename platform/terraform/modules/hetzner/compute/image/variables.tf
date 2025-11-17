variable "type" {
  description = "Type of image (snapshot or backup)"
  type        = string
  default     = "snapshot"
}

variable "description" {
  description = "Description of the image"
  type        = string
  default     = null
}

variable "labels" {
  description = "Labels"
  type        = map(string)
  default     = {}
}
