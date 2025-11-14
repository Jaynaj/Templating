resource "aws_acm_certificate_validation" "this" {
  # Configure your ACM certificate validation here

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}
