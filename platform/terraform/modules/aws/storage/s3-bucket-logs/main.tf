resource "aws_s3_bucket" "this" {
  # Configure your S3 bucket for logs here

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}
