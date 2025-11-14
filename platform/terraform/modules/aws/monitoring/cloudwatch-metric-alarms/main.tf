resource "aws_cloudwatch_metric_alarm" "this" {
  # Configure your CloudWatch metric alarm here

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}
