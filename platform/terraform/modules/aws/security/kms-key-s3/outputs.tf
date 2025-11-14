output "id" {
  description = "ID of the key"
  value       = aws_kms_key.this.id
}

output "arn" {
  description = "ARN of the key"
  value       = try(aws_kms_key.this.arn, null)
}
