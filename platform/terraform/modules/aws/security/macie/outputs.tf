output "id" {
  description = "ID of the account"
  value       = aws_macie2_account.this.id
}

output "arn" {
  description = "ARN of the account"
  value       = try(aws_macie2_account.this.arn, null)
}
