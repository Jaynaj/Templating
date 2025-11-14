resource "aws_s3_bucket" "this" {
  # Configure your S3 bucket for static website here

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}
