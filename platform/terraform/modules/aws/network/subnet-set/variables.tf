variable "name_prefix" {
  description = "Prefix for subnet names"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "newbits" {
  description = "Number of additional bits for subnet CIDR"
  type        = number
  default     = 8
}

variable "map_public_ip_on_launch" {
  description = "Map public IP on launch for public subnets"
  type        = bool
  default     = true
}

variable "create_database_subnets" {
  description = "Create database subnets"
  type        = bool
  default     = false
}

variable "create_database_subnet_group" {
  description = "Create database subnet group"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
