resource "aws_rds_cluster" "this" {
  cluster_identifier      = var.cluster_identifier
  engine                  = "aurora-postgresql"
  engine_version          = var.engine_version
  engine_mode             = var.engine_mode
  database_name           = var.database_name
  master_username         = var.master_username
  master_password         = var.master_password
  port                    = var.port

  vpc_security_group_ids = var.vpc_security_group_ids
  db_subnet_group_name   = var.db_subnet_group_name
  availability_zones     = var.availability_zones

  backup_retention_period      = var.backup_retention_period
  preferred_backup_window      = var.preferred_backup_window
  preferred_maintenance_window = var.preferred_maintenance_window
  copy_tags_to_snapshot        = var.copy_tags_to_snapshot
  skip_final_snapshot          = var.skip_final_snapshot
  final_snapshot_identifier    = var.skip_final_snapshot ? null : "${var.cluster_identifier}-final-${formatdate("YYYY-MM-DD-hhmm", timestamp())}"

  storage_encrypted                   = var.storage_encrypted
  kms_key_id                          = var.kms_key_id
  iam_database_authentication_enabled = var.iam_database_authentication_enabled

  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports

  deletion_protection = var.deletion_protection
  apply_immediately   = var.apply_immediately

  db_cluster_parameter_group_name  = var.db_cluster_parameter_group_name
  db_instance_parameter_group_name = var.db_instance_parameter_group_name

  enable_http_endpoint = var.enable_http_endpoint

  dynamic "serverlessv2_scaling_configuration" {
    for_each = var.serverlessv2_scaling_configuration != null ? [var.serverlessv2_scaling_configuration] : []
    content {
      min_capacity = serverlessv2_scaling_configuration.value.min_capacity
      max_capacity = serverlessv2_scaling_configuration.value.max_capacity
    }
  }

  dynamic "scaling_configuration" {
    for_each = var.engine_mode == "serverless" && var.scaling_configuration != null ? [var.scaling_configuration] : []
    content {
      auto_pause               = lookup(scaling_configuration.value, "auto_pause", true)
      max_capacity             = lookup(scaling_configuration.value, "max_capacity", 16)
      min_capacity             = lookup(scaling_configuration.value, "min_capacity", 2)
      seconds_until_auto_pause = lookup(scaling_configuration.value, "seconds_until_auto_pause", 300)
      timeout_action           = lookup(scaling_configuration.value, "timeout_action", "RollbackCapacityChange")
    }
  }

  dynamic "restore_to_point_in_time" {
    for_each = var.restore_to_point_in_time != null ? [var.restore_to_point_in_time] : []
    content {
      source_cluster_identifier  = lookup(restore_to_point_in_time.value, "source_cluster_identifier", null)
      restore_type               = lookup(restore_to_point_in_time.value, "restore_type", "full-copy")
      use_latest_restorable_time = lookup(restore_to_point_in_time.value, "use_latest_restorable_time", true)
      restore_to_time            = lookup(restore_to_point_in_time.value, "restore_to_time", null)
    }
  }

  backtrack_window = var.backtrack_window

  tags = merge(
    var.tags,
    {
      Name   = var.cluster_identifier
      Engine = "aurora-postgresql"
    }
  )

  lifecycle {
    ignore_changes = [final_snapshot_identifier]
  }
}

resource "aws_rds_cluster_instance" "this" {
  count = var.instance_count

  identifier         = "${var.cluster_identifier}-${count.index + 1}"
  cluster_identifier = aws_rds_cluster.this.id
  instance_class     = var.instance_class
  engine             = aws_rds_cluster.this.engine
  engine_version     = aws_rds_cluster.this.engine_version

  publicly_accessible = var.publicly_accessible

  monitoring_interval = var.monitoring_interval
  monitoring_role_arn = var.monitoring_role_arn

  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_kms_key_id       = var.performance_insights_kms_key_id
  performance_insights_retention_period = var.performance_insights_retention_period

  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  apply_immediately          = var.apply_immediately

  db_parameter_group_name = var.db_instance_parameter_group_name

  ca_cert_identifier = var.ca_cert_identifier

  promotion_tier = count.index

  tags = merge(
    var.tags,
    {
      Name = "${var.cluster_identifier}-${count.index + 1}"
      Tier = count.index == 0 ? "writer" : "reader"
    }
  )
}

# Aurora Auto Scaling
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
    target_value = var.autoscaling_target_cpu

    predefined_metric_specification {
      predefined_metric_type = "RDSReaderAverageCPUUtilization"
    }

    scale_in_cooldown  = var.autoscaling_scale_in_cooldown
    scale_out_cooldown = var.autoscaling_scale_out_cooldown
  }
}
