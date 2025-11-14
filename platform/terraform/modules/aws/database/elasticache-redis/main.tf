resource "aws_elasticache_replication_group" "this" {
  replication_group_id       = var.replication_group_id
  replication_group_description = var.description
  engine                     = "redis"
  engine_version             = var.engine_version
  node_type                  = var.node_type
  num_cache_clusters         = var.cluster_mode_enabled ? null : var.num_cache_clusters
  port                       = var.port
  parameter_group_name       = var.parameter_group_name
  subnet_group_name          = var.subnet_group_name
  security_group_ids         = var.security_group_ids

  automatic_failover_enabled = var.automatic_failover_enabled
  multi_az_enabled           = var.multi_az_enabled

  at_rest_encryption_enabled = var.at_rest_encryption_enabled
  transit_encryption_enabled = var.transit_encryption_enabled
  auth_token                 = var.auth_token_enabled ? var.auth_token : null
  kms_key_id                 = var.kms_key_id

  snapshot_retention_limit = var.snapshot_retention_limit
  snapshot_window          = var.snapshot_window
  maintenance_window       = var.maintenance_window
  notification_topic_arn   = var.notification_topic_arn

  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  apply_immediately          = var.apply_immediately

  data_tiering_enabled = var.data_tiering_enabled

  dynamic "log_delivery_configuration" {
    for_each = var.log_delivery_configuration
    content {
      destination      = log_delivery_configuration.value.destination
      destination_type = log_delivery_configuration.value.destination_type
      log_format       = log_delivery_configuration.value.log_format
      log_type         = log_delivery_configuration.value.log_type
    }
  }

  dynamic "cluster_mode" {
    for_each = var.cluster_mode_enabled ? [var.cluster_mode] : []
    content {
      num_node_groups         = cluster_mode.value.num_node_groups
      replicas_per_node_group = cluster_mode.value.replicas_per_node_group
    }
  }

  user_group_ids = var.user_group_ids

  tags = merge(
    var.tags,
    {
      Name = var.replication_group_id
    }
  )
}

# Subnet Group (if creating new)
resource "aws_elasticache_subnet_group" "this" {
  count = var.create_subnet_group ? 1 : 0

  name       = "${var.replication_group_id}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = merge(
    var.tags,
    {
      Name = "${var.replication_group_id}-subnet-group"
    }
  )
}

# Parameter Group (if creating new)
resource "aws_elasticache_parameter_group" "this" {
  count = var.create_parameter_group ? 1 : 0

  name   = "${var.replication_group_id}-params"
  family = var.parameter_group_family

  dynamic "parameter" {
    for_each = var.parameters
    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.replication_group_id}-params"
    }
  )
}
