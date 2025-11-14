variable "name" {
  description = "Name prefix for EIPs"
  type        = string
}

variable "eip_count" {
  description = "Number of EIPs to create"
  type        = number
  default     = 1
}

variable "network_interface_ids" {
  description = "Network interface IDs"
  type        = list(string)
  default     = []
}

variable "instance_ids" {
  description = "EC2 instance IDs"
  type        = list(string)
  default     = []
}

variable "associate_with_private_ip" {
  description = "Private IP to associate with"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}