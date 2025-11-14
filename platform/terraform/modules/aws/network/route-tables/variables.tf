variable "name" {
  description = "Name of the route table"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "routes" {
  description = "List of route objects"
  type        = list(any)
  default     = []
}

variable "subnet_ids" {
  description = "List of subnet IDs to associate with this route table"
  type        = list(string)
  default     = []
}

variable "gateway_id" {
  description = "Gateway ID for route table association"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}