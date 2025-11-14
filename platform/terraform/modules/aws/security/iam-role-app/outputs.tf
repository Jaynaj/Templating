output "id" {
  description = "ID of the role"
  value       = aws_iam_role.this.id
}

output "arn" {
  description = "ARN of the role"
  value       = try(aws_iam_role.this.arn, null)
}
