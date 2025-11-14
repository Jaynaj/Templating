resource "aws_secretsmanager_secret" "this" {
  # Configure your Secrets Manager secret here

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}
