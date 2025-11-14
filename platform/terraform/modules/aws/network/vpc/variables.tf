variable "name" {
  description = "Name of the VPC"
  type        = string
}

variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "instance_tenancy" {
  description = "Tenancy option for instances (default, dedicated, host)"
  type        = string
  default     = "default"
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Enable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "enable_network_address_usage_metrics" {
  description = "Enable network address usage metrics"
  type        = bool
  default     = false
}

variable "create_igw" {
  description = "Create an Internet Gateway for the VPC"
  type        = bool
  default     = true
}

variable "enable_dhcp_options" {
  description = "Enable DHCP options"
  type        = bool
  default     = false
}

variable "dhcp_options_domain_name" {
  description = "Domain name for DHCP options"
  type        = string
  default     = ""
}

variable "dhcp_options_domain_name_servers" {
  description = "List of name servers for DHCP options"
  type        = list(string)
  default     = ["AmazonProvidedDNS"]
}

variable "dhcp_options_ntp_servers" {
  description = "List of NTP servers for DHCP options"
  type        = list(string)
  default     = []
}

variable "dhcp_options_netbios_name_servers" {
  description = "List of NetBIOS name servers"
  type        = list(string)
  default     = []
}

variable "dhcp_options_netbios_node_type" {
  description = "NetBIOS node type"
  type        = number
  default     = 2
}

variable "enable_flow_logs" {
  description = "Enable VPC Flow Logs"
  type        = bool
  default     = true
}

variable "flow_logs_destination_type" {
  description = "Type of flow log destination (cloud-watch-logs or s3)"
  type        = string
  default     = "cloud-watch-logs"
}

variable "flow_logs_destination_arn" {
  description = "ARN of the flow log destination"
  type        = string
  default     = ""
}

variable "flow_logs_traffic_type" {
  description = "Type of traffic to log (ACCEPT, REJECT, ALL)"
  type        = string
  default     = "ALL"
}

variable "flow_logs_iam_role_arn" {
  description = "IAM role ARN for flow logs"
  type        = string
  default     = ""
}

variable "flow_logs_log_format" {
  description = "Fields to include in flow log records"
  type        = string
  default     = null
}

variable "flow_logs_max_aggregation_interval" {
  description = "Maximum aggregation interval for flow logs (60 or 600)"
  type        = number
  default     = 600
}

variable "flow_logs_file_format" {
  description = "File format for flow logs (plain-text or parquet)"
  type        = string
  default     = "plain-text"
}

variable "flow_logs_per_hour_partition" {
  description = "Enable per-hour partitioning for flow logs"
  type        = bool
  default     = false
}

variable "manage_default_security_group" {
  description = "Manage the default security group"
  type        = bool
  default     = true
}

variable "default_security_group_ingress" {
  description = "Ingress rules for default security group"
  type        = list(any)
  default     = []
}

variable "default_security_group_egress" {
  description = "Egress rules for default security group"
  type        = list(any)
  default     = []
}

variable "manage_default_network_acl" {
  description = "Manage the default network ACL"
  type        = bool
  default     = false
}

variable "default_network_acl_ingress" {
  description = "Ingress rules for default network ACL"
  type        = list(any)
  default     = []
}

variable "default_network_acl_egress" {
  description = "Egress rules for default network ACL"
  type        = list(any)
  default     = []
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
