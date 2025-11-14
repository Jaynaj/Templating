resource "aws_acm_certificate" "this" {
  # Configure your ACM certificate here

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}
