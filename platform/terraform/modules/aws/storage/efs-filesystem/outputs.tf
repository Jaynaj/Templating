output "file_system_id" {
  description = "EFS file system ID"
  value       = aws_efs_file_system.this.id
}

output "file_system_arn" {
  description = "EFS file system ARN"
  value       = aws_efs_file_system.this.arn
}

output "file_system_dns_name" {
  description = "DNS name for the file system"
  value       = aws_efs_file_system.this.dns_name
}

output "mount_target_ids" {
  description = "List of mount target IDs"
  value       = aws_efs_mount_target.this[*].id
}

output "mount_target_dns_names" {
  description = "List of mount target DNS names"
  value       = aws_efs_mount_target.this[*].dns_name
}

output "mount_target_network_interface_ids" {
  description = "List of network interface IDs for mount targets"
  value       = aws_efs_mount_target.this[*].network_interface_id
}

output "access_point_ids" {
  description = "Map of access point IDs"
  value       = { for k, v in aws_efs_access_point.this : k => v.id }
}

output "access_point_arns" {
  description = "Map of access point ARNs"
  value       = { for k, v in aws_efs_access_point.this : k => v.arn }
}

output "mount_command" {
  description = "Example mount command"
  value       = "sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${aws_efs_file_system.this.dns_name}:/ /mnt/efs"
}
