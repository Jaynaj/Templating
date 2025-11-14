resource "aws_guardduty_detector" "this" {
  # Configure your GuardDuty detector here

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}
