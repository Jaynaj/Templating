output "id" {
  description = "ID of the cloudtrail"
  value       = aws_cloudtrail.this.id
}

output "arn" {
  description = "ARN of the cloudtrail"
  value       = try(aws_cloudtrail.this.arn, null)
}
