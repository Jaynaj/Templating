resource "aws_iam_policy" "this" {
  name        = var.name
  description = var.description
  policy      = var.policy
  path        = var.path

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}
