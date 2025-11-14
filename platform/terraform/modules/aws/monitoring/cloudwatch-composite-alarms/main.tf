resource "aws_cloudwatch_composite_alarm" "this" {
  # Configure your CloudWatch composite alarm here

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}
