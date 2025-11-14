resource "aws_acm_certificate_validation" "this" {
  certificate_arn         = var.certificate_arn
  validation_record_fqdns = length(var.validation_record_fqdns) > 0 ? var.validation_record_fqdns : null

  timeouts {
    create = var.validation_timeout
  }
}
