resource "aws_rds_cluster" "this" {
  cluster_identifier = var.cluster_identifier
  engine             = var.engine
  engine_version     = var.engine_version
  engine_mode        = var.engine_mode
  database_name      = var.database_name
  master_username    = var.master_username
  master_password    = var.master_password
  port               = var.port

  # Network configuration
  db_subnet_group_name            = var.db_subnet_group_name
  vpc_security_group_ids          = var.vpc_security_group_ids
  availability_zones              = var.availability_zones
  db_cluster_parameter_group_name = var.db_cluster_parameter_group_name != null ? var.db_cluster_parameter_group_name : aws_rds_cluster_parameter_group.this[0].name

  # Backup configuration
  backup_retention_period      = var.backup_retention_period
  preferred_backup_window      = var.preferred_backup_window
  preferred_maintenance_window = var.preferred_maintenance_window
  copy_tags_to_snapshot        = var.copy_tags_to_snapshot
  skip_final_snapshot          = var.skip_final_snapshot
  final_snapshot_identifier    = var.skip_final_snapshot ? null : "${var.cluster_identifier}-final-snapshot"

  # Encryption
  storage_encrypted = var.storage_encrypted
  kms_key_id        = var.kms_key_id

  # Backtrack (MySQL 5.7 compatible mode only)
  backtrack_window = var.backtrack_window

  # CloudWatch Logs
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports

  # IAM authentication
  iam_database_authentication_enabled = var.iam_database_authentication_enabled

  # Deletion protection
  deletion_protection = var.deletion_protection

  # Serverless v2 scaling
  dynamic "serverlessv2_scaling_configuration" {
    for_each = var.serverlessv2_scaling_configuration != null ? [var.serverlessv2_scaling_configuration] : []
    content {
      min_capacity = serverlessv2_scaling_configuration.value.min_capacity
      max_capacity = serverlessv2_scaling_configuration.value.max_capacity
    }
  }

  # Global cluster
  global_cluster_identifier = var.global_cluster_identifier

  # Restore from snapshot
  snapshot_identifier = var.snapshot_identifier

  # Restore to point in time
  dynamic "restore_to_point_in_time" {
    for_each = var.restore_to_point_in_time != null ? [var.restore_to_point_in_time] : []
    content {
      source_cluster_identifier  = restore_to_point_in_time.value.source_cluster_identifier
      restore_type               = lookup(restore_to_point_in_time.value, "restore_type", "full-copy")
      use_latest_restorable_time = lookup(restore_to_point_in_time.value, "use_latest_restorable_time", null)
      restore_to_time            = lookup(restore_to_point_in_time.value, "restore_to_time", null)
    }
  }

  # Apply changes immediately
  apply_immediately = var.apply_immediately

  tags = merge(
    var.tags,
    {
      Name   = var.cluster_identifier
      Engine = var.engine
    }
  )

  lifecycle {
    ignore_changes = [
      snapshot_identifier,
      restore_to_point_in_time
    ]
  }
}

# Default cluster parameter group
resource "aws_rds_cluster_parameter_group" "this" {
  count = var.db_cluster_parameter_group_name == null ? 1 : 0

  name        = "${var.cluster_identifier}-cluster-params"
  family      = var.db_cluster_parameter_group_family
  description = "Cluster parameter group for ${var.cluster_identifier}"

  dynamic "parameter" {
    for_each = var.cluster_parameters
    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = lookup(parameter.value, "apply_method", "immediate")
    }
  }

  tags = var.tags
}

# Cluster instances
resource "aws_rds_cluster_instance" "this" {
  count = var.instance_count

  identifier         = "${var.cluster_identifier}-${count.index + 1}"
  cluster_identifier = aws_rds_cluster.this.id
  instance_class     = var.instance_class
  engine             = aws_rds_cluster.this.engine
  engine_version     = aws_rds_cluster.this.engine_version

  # Performance Insights
  performance_insights_enabled    = var.performance_insights_enabled
  performance_insights_kms_key_id = var.performance_insights_kms_key_id
  performance_insights_retention_period = var.performance_insights_retention_period

  # Monitoring
  monitoring_interval = var.monitoring_interval
  monitoring_role_arn = var.monitoring_interval > 0 ? var.monitoring_role_arn : null

  # Parameter group
  db_parameter_group_name = var.db_parameter_group_name != null ? var.db_parameter_group_name : aws_db_parameter_group.this[0].name

  # Auto minor version upgrade
  auto_minor_version_upgrade = var.auto_minor_version_upgrade

  # Publicly accessible
  publicly_accessible = var.publicly_accessible

  # Availability zone
  availability_zone = length(var.instance_availability_zones) > count.index ? var.instance_availability_zones[count.index] : null

  # Promotion tier (for failover priority)
  promotion_tier = count.index

  # Apply changes immediately
  apply_immediately = var.apply_immediately

  tags = merge(
    var.tags,
    {
      Name = "${var.cluster_identifier}-${count.index + 1}"
      Type = count.index == 0 ? "writer" : "reader"
      Tier = count.index
    }
  )
}

# Default DB parameter group
resource "aws_db_parameter_group" "this" {
  count = var.db_parameter_group_name == null ? 1 : 0

  name        = "${var.cluster_identifier}-instance-params"
  family      = var.db_parameter_group_family
  description = "Instance parameter group for ${var.cluster_identifier}"

  dynamic "parameter" {
    for_each = var.instance_parameters
    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = lookup(parameter.value, "apply_method", "immediate")
    }
  }

  tags = var.tags
}

# Auto-scaling for read replicas
resource "aws_appautoscaling_target" "replicas" {
  count = var.enable_autoscaling ? 1 : 0

  max_capacity       = var.autoscaling_max_capacity
  min_capacity       = var.autoscaling_min_capacity
  resource_id        = "cluster:${aws_rds_cluster.this.cluster_identifier}"
  scalable_dimension = "rds:cluster:ReadReplicaCount"
  service_namespace  = "rds"
}

resource "aws_appautoscaling_policy" "replicas" {
  count = var.enable_autoscaling ? 1 : 0

  name               = "${var.cluster_identifier}-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.replicas[0].resource_id
  scalable_dimension = aws_appautoscaling_target.replicas[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.replicas[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = var.autoscaling_metric_type
    }

    target_value       = var.autoscaling_target_value
    scale_in_cooldown  = var.autoscaling_scale_in_cooldown
    scale_out_cooldown = var.autoscaling_scale_out_cooldown
  }
}
