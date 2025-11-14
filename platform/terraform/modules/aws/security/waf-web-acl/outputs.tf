output "id" {
  description = "ID of the acl"
  value       = aws_wafv2_web_acl.this.id
}

output "arn" {
  description = "ARN of the acl"
  value       = try(aws_wafv2_web_acl.this.arn, null)
}
