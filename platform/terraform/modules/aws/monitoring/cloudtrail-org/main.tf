resource "aws_cloudtrail" "this" {
  # Configure your CloudTrail for organization here

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}
