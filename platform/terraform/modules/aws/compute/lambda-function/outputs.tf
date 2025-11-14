output "function_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.this.arn
}

output "function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.this.function_name
}

output "function_qualified_arn" {
  description = "Qualified ARN of the Lambda function"
  value       = aws_lambda_function.this.qualified_arn
}

output "function_version" {
  description = "Latest published version of the function"
  value       = aws_lambda_function.this.version
}

output "function_last_modified" {
  description = "Date the function was last modified"
  value       = aws_lambda_function.this.last_modified
}

output "function_invoke_arn" {
  description = "ARN to use for invoking the function"
  value       = aws_lambda_function.this.invoke_arn
}

output "function_url" {
  description = "Function URL endpoint"
  value       = try(aws_lambda_function_url.this[0].function_url, null)
}

output "cloudwatch_log_group_name" {
  description = "Name of the CloudWatch log group"
  value       = try(aws_cloudwatch_log_group.this[0].name, null)
}

output "cloudwatch_log_group_arn" {
  description = "ARN of the CloudWatch log group"
  value       = try(aws_cloudwatch_log_group.this[0].arn, null)
}
