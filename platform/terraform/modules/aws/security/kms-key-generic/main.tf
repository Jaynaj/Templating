resource "aws_kms_key" "this" {
  # Configure your KMS key here

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}
