output "id" {
  description = "ID of the system"
  value       = aws_fsx_lustre_file_system.this.id
}

output "arn" {
  description = "ARN of the system"
  value       = try(aws_fsx_lustre_file_system.this.arn, null)
}
