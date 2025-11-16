resource "aws_xray_sampling_rule" "this" {
  for_each = { for rule in var.sampling_rules : rule.rule_name => rule }

  rule_name      = each.value.rule_name
  priority       = each.value.priority
  version        = lookup(each.value, "version", 1)
  reservoir_size = each.value.reservoir_size
  fixed_rate     = each.value.fixed_rate
  url_path       = each.value.url_path
  host           = each.value.host
  http_method    = each.value.http_method
  service_type   = each.value.service_type
  service_name   = each.value.service_name
  resource_arn   = each.value.resource_arn

  tags = merge(
    var.tags,
    {
      Name = each.value.rule_name
    }
  )
}

resource "aws_xray_encryption_config" "this" {
  count = var.enable_encryption ? 1 : 0

  type   = var.encryption_type
  key_id = var.encryption_type == "KMS" ? var.kms_key_id : null
}
