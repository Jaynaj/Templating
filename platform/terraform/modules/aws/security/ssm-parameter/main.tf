resource "aws_ssm_parameter" "this" {
  # Configure your SSM Parameter here

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}
