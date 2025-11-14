output "id" {
  description = "ID of the secret"
  value       = aws_secretsmanager_secret.this.id
}

output "arn" {
  description = "ARN of the secret"
  value       = try(aws_secretsmanager_secret.this.arn, null)
}
