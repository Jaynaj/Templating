resource "aws_iam_role" "this" {
  # Configure your IAM role for CI/CD here

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}
