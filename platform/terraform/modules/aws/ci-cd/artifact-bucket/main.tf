resource "aws_s3_bucket" "this" {
  # Configure your S3 bucket for artifacts here

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}
