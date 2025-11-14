resource "aws_cloudwatch_event_rule" "this" {
  # Configure your EventBridge rule here

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}
