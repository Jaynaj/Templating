resource "aws_kms_key" "this" {
  # Configure your KMS key for S3 here

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}
