resource "aws_route53_zone" "this" {
  # Configure your Route53 hosted zone here

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}
