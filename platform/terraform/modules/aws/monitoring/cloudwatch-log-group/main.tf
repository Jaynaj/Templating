resource "aws_cloudwatch_log_group" "this" {
  # Configure your CloudWatch log group here

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}
