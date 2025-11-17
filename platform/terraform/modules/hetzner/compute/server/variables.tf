variable "name" {
  description = "Name of the server"
  type        = string
}

variable "server_type" {
  description = "Server type (e.g., cx11, cx21, cx31, cpx11, cpx21)"
  type        = string
}

variable "image" {
  description = "Image name or ID (e.g., ubuntu-22.04, debian-11)"
  type        = string
}

variable "location" {
  description = "Location (nbg1, fsn1, hel1, ash, hil)"
  type        = string
  default     = null
}

variable "datacenter" {
  description = "Datacenter (nbg1-dc3, fsn1-dc14, hel1-dc2, ash-dc1, hil-dc1)"
  type        = string
  default     = null
}

variable "ssh_keys" {
  description = "List of SSH key IDs or names"
  type        = list(string)
  default     = []
}

variable "user_data" {
  description = "Cloud-init user data"
  type        = string
  default     = null
}

variable "public_net" {
  description = "Public network configuration"
  type = object({
    ipv4_enabled = optional(bool)
    ipv6_enabled = optional(bool)
    ipv4         = optional(number)
    ipv6         = optional(number)
  })
  default = null
}

variable "network" {
  description = "Private network attachments"
  type = list(object({
    network_id = number
    ip         = optional(string)
    alias_ips  = optional(list(string))
  }))
  default = []
}

variable "firewall_ids" {
  description = "List of firewall IDs"
  type        = list(number)
  default     = []
}

variable "placement_group_id" {
  description = "Placement group ID"
  type        = number
  default     = null
}

variable "backups" {
  description = "Enable backups"
  type        = bool
  default     = false
}

variable "iso" {
  description = "ISO ID or name to mount"
  type        = string
  default     = null
}

variable "rescue" {
  description = "Enable rescue mode"
  type        = string
  default     = null
}

variable "labels" {
  description = "Labels"
  type        = map(string)
  default     = {}
}

variable "keep_disk" {
  description = "Keep disk on delete"
  type        = bool
  default     = false
}

variable "delete_protection" {
  description = "Enable delete protection"
  type        = bool
  default     = false
}

variable "rebuild_protection" {
  description = "Enable rebuild protection"
  type        = bool
  default     = false
}
