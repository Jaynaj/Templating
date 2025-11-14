resource "aws_route53_record" "this" {
  # Configure your Route53 record here

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}
