variable "name" {
  description = "Name of the Transit Gateway"
  type        = string
}

variable "description" {
  description = "Description of the Transit Gateway"
  type        = string
  default     = ""
}

variable "amazon_side_asn" {
  description = "ASN for the Amazon side of the BGP session"
  type        = number
  default     = 64512
}

variable "default_route_table_association" {
  description = "Enable default route table association"
  type        = string
  default     = "enable"
}

variable "default_route_table_propagation" {
  description = "Enable default route table propagation"
  type        = string
  default     = "enable"
}

variable "dns_support" {
  description = "Enable DNS support"
  type        = string
  default     = "enable"
}

variable "vpn_ecmp_support" {
  description = "Enable VPN ECMP support"
  type        = string
  default     = "enable"
}

variable "auto_accept_shared_attachments" {
  description = "Auto accept shared attachments"
  type        = string
  default     = "disable"
}

variable "multicast_support" {
  description = "Enable multicast support"
  type        = string
  default     = "disable"
}

variable "transit_gateway_cidr_blocks" {
  description = "CIDR blocks for the Transit Gateway"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
