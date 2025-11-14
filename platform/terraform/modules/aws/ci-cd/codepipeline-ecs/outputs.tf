output "id" {
  description = "ID of the codepipeline"
  value       = aws_codepipeline.this.id
}

output "arn" {
  description = "ARN of the codepipeline"
  value       = try(aws_codepipeline.this.arn, null)
}
