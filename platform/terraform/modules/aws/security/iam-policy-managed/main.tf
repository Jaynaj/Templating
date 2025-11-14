resource "aws_iam_policy" "this" {
  # Configure your Managed IAM policy here

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}
