resource "aws_wafv2_web_acl" "this" {
  # Configure your WAF Web ACL here

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}
