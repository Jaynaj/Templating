resource "hcloud_firewall" "this" {
  name   = var.name
  labels = var.labels

  dynamic "rule" {
    for_each = var.rules
    content {
      direction       = rule.value.direction
      protocol        = rule.value.protocol
      port            = lookup(rule.value, "port", null)
      source_ips      = lookup(rule.value, "source_ips", null)
      destination_ips = lookup(rule.value, "destination_ips", null)
      description     = lookup(rule.value, "description", null)
    }
  }

  dynamic "apply_to" {
    for_each = var.apply_to
    content {
      server         = lookup(apply_to.value, "server", null)
      label_selector = lookup(apply_to.value, "label_selector", null)
    }
  }
}
