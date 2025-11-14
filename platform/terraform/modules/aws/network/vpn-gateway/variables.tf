variable "name" {
  description = "Name of the VPN Gateway"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID to attach the VPN Gateway"
  type        = string
}

variable "amazon_side_asn" {
  description = "ASN for the Amazon side of the VPN gateway"
  type        = string
  default     = null
}

variable "availability_zone" {
  description = "Availability zone for the VPN Gateway"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
