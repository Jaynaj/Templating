output "id" {
  description = "ID of the project"
  value       = aws_codebuild_project.this.id
}

output "arn" {
  description = "ARN of the project"
  value       = try(aws_codebuild_project.this.arn, null)
}
