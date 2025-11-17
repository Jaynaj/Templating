resource "hcloud_load_balancer" "this" {
  name               = var.name
  load_balancer_type = var.load_balancer_type
  location           = var.location
  network_zone       = var.network_zone
  algorithm          = var.algorithm
  labels             = var.labels
  delete_protection  = var.delete_protection
}

resource "hcloud_load_balancer_network" "this" {
  count = var.network_id != null ? 1 : 0

  load_balancer_id = hcloud_load_balancer.this.id
  network_id       = var.network_id
}

resource "hcloud_load_balancer_service" "this" {
  for_each = { for idx, service in var.services : idx => service }

  load_balancer_id = hcloud_load_balancer.this.id
  protocol         = each.value.protocol
  listen_port      = each.value.listen_port
  destination_port = each.value.destination_port
  proxyprotocol    = lookup(each.value, "proxyprotocol", false)

  dynamic "http" {
    for_each = lookup(each.value, "http", null) != null ? [each.value.http] : []
    content {
      sticky_sessions = lookup(http.value, "sticky_sessions", false)
      cookie_name     = lookup(http.value, "cookie_name", null)
      cookie_lifetime = lookup(http.value, "cookie_lifetime", null)
      certificates    = lookup(http.value, "certificates", null)
      redirect_http   = lookup(http.value, "redirect_http", false)
    }
  }

  health_check {
    protocol = each.value.health_check.protocol
    port     = each.value.health_check.port
    interval = each.value.health_check.interval
    timeout  = each.value.health_check.timeout
    retries  = each.value.health_check.retries

    dynamic "http" {
      for_each = lookup(each.value.health_check, "http", null) != null ? [each.value.health_check.http] : []
      content {
        domain       = lookup(http.value, "domain", null)
        path         = lookup(http.value, "path", "/")
        response     = lookup(http.value, "response", null)
        status_codes = lookup(http.value, "status_codes", null)
        tls          = lookup(http.value, "tls", false)
      }
    }
  }
}

resource "hcloud_load_balancer_target" "this" {
  for_each = { for idx, target in var.targets : idx => target }

  type             = each.value.type
  load_balancer_id = hcloud_load_balancer.this.id
  server_id        = lookup(each.value, "server_id", null)
  label_selector   = lookup(each.value, "label_selector", null)
  ip               = lookup(each.value, "ip", null)
  use_private_ip   = lookup(each.value, "use_private_ip", false)
}
