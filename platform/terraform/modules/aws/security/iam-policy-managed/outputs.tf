output "id" {
  description = "ID of the policy"
  value       = aws_iam_policy.this.id
}

output "arn" {
  description = "ARN of the policy"
  value       = try(aws_iam_policy.this.arn, null)
}
