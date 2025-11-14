# Lustre outputs
output "lustre_file_system_id" {
  description = "Lustre file system ID"
  value       = try(aws_fsx_lustre_file_system.this[0].id, null)
}

output "lustre_arn" {
  description = "Lustre ARN"
  value       = try(aws_fsx_lustre_file_system.this[0].arn, null)
}

output "lustre_dns_name" {
  description = "Lustre DNS name"
  value       = try(aws_fsx_lustre_file_system.this[0].dns_name, null)
}

output "lustre_mount_name" {
  description = "Lustre mount name"
  value       = try(aws_fsx_lustre_file_system.this[0].mount_name, null)
}

output "lustre_mount_command" {
  description = "Example Lustre mount command"
  value = var.file_system_type == "LUSTRE" ? "sudo mount -t lustre ${try(aws_fsx_lustre_file_system.this[0].dns_name, "")}@tcp:/${try(aws_fsx_lustre_file_system.this[0].mount_name, "")} /mnt/fsx" : null
}

# Windows outputs
output "windows_file_system_id" {
  description = "Windows file system ID"
  value       = try(aws_fsx_windows_file_system.this[0].id, null)
}

output "windows_arn" {
  description = "Windows ARN"
  value       = try(aws_fsx_windows_file_system.this[0].arn, null)
}

output "windows_dns_name" {
  description = "Windows DNS name"
  value       = try(aws_fsx_windows_file_system.this[0].dns_name, null)
}

output "windows_remote_administration_endpoint" {
  description = "Windows remote administration endpoint"
  value       = try(aws_fsx_windows_file_system.this[0].remote_administration_endpoint, null)
}

output "windows_preferred_file_server_ip" {
  description = "Windows preferred file server IP"
  value       = try(aws_fsx_windows_file_system.this[0].preferred_file_server_ip, null)
}

output "windows_mount_command" {
  description = "Example Windows mount command"
  value = var.file_system_type == "WINDOWS" ? "net use Z: \\\\${try(aws_fsx_windows_file_system.this[0].dns_name, "")}\\share" : null
}

# ONTAP outputs
output "ontap_file_system_id" {
  description = "ONTAP file system ID"
  value       = try(aws_fsx_ontap_file_system.this[0].id, null)
}

output "ontap_arn" {
  description = "ONTAP ARN"
  value       = try(aws_fsx_ontap_file_system.this[0].arn, null)
}

output "ontap_endpoints" {
  description = "ONTAP endpoints"
  value       = try(aws_fsx_ontap_file_system.this[0].endpoints, null)
}

output "ontap_management_endpoint" {
  description = "ONTAP management endpoint DNS name"
  value       = try(aws_fsx_ontap_file_system.this[0].endpoints[0].management[0].dns_name, null)
}

output "ontap_intercluster_endpoint" {
  description = "ONTAP intercluster endpoint DNS name"
  value       = try(aws_fsx_ontap_file_system.this[0].endpoints[0].intercluster[0].dns_name, null)
}

# OpenZFS outputs
output "openzfs_file_system_id" {
  description = "OpenZFS file system ID"
  value       = try(aws_fsx_openzfs_file_system.this[0].id, null)
}

output "openzfs_arn" {
  description = "OpenZFS ARN"
  value       = try(aws_fsx_openzfs_file_system.this[0].arn, null)
}

output "openzfs_dns_name" {
  description = "OpenZFS DNS name"
  value       = try(aws_fsx_openzfs_file_system.this[0].dns_name, null)
}

output "openzfs_root_volume_id" {
  description = "OpenZFS root volume ID"
  value       = try(aws_fsx_openzfs_file_system.this[0].root_volume_id, null)
}

output "openzfs_mount_command" {
  description = "Example OpenZFS mount command"
  value = var.file_system_type == "OPENZFS" ? "sudo mount -t nfs -o nfsvers=3 ${try(aws_fsx_openzfs_file_system.this[0].dns_name, "")}:/fsx /mnt/fsx" : null
}

# Common outputs (work with any type)
output "file_system_id" {
  description = "File system ID (works with any type)"
  value = (
    var.file_system_type == "LUSTRE" ? try(aws_fsx_lustre_file_system.this[0].id, null) :
    var.file_system_type == "WINDOWS" ? try(aws_fsx_windows_file_system.this[0].id, null) :
    var.file_system_type == "ONTAP" ? try(aws_fsx_ontap_file_system.this[0].id, null) :
    var.file_system_type == "OPENZFS" ? try(aws_fsx_openzfs_file_system.this[0].id, null) :
    null
  )
}

output "file_system_arn" {
  description = "File system ARN (works with any type)"
  value = (
    var.file_system_type == "LUSTRE" ? try(aws_fsx_lustre_file_system.this[0].arn, null) :
    var.file_system_type == "WINDOWS" ? try(aws_fsx_windows_file_system.this[0].arn, null) :
    var.file_system_type == "ONTAP" ? try(aws_fsx_ontap_file_system.this[0].arn, null) :
    var.file_system_type == "OPENZFS" ? try(aws_fsx_openzfs_file_system.this[0].arn, null) :
    null
  )
}

output "dns_name" {
  description = "DNS name (works with any type except ONTAP)"
  value = (
    var.file_system_type == "LUSTRE" ? try(aws_fsx_lustre_file_system.this[0].dns_name, null) :
    var.file_system_type == "WINDOWS" ? try(aws_fsx_windows_file_system.this[0].dns_name, null) :
    var.file_system_type == "OPENZFS" ? try(aws_fsx_openzfs_file_system.this[0].dns_name, null) :
    null
  )
}
