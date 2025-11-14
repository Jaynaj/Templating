resource "aws_iam_role" "this" {
  # Configure your Generic IAM role here

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}
