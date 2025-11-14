resource "aws_db_instance" "this" {
  identifier     = var.identifier
  engine         = "mysql"
  engine_version = var.engine_version

  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage
  storage_type      = var.storage_type
  storage_encrypted = var.storage_encrypted
  kms_key_id        = var.kms_key_id
  iops              = var.iops
  storage_throughput = var.storage_throughput

  db_name  = var.db_name
  username = var.username
  password = var.password
  port     = var.port

  vpc_security_group_ids = var.vpc_security_group_ids
  db_subnet_group_name   = var.db_subnet_group_name
  publicly_accessible    = var.publicly_accessible
  availability_zone      = var.multi_az ? null : var.availability_zone

  backup_retention_period      = var.backup_retention_period
  backup_window                = var.backup_window
  maintenance_window           = var.maintenance_window
  copy_tags_to_snapshot        = var.copy_tags_to_snapshot
  skip_final_snapshot          = var.skip_final_snapshot
  final_snapshot_identifier    = var.skip_final_snapshot ? null : "${var.identifier}-final-snapshot-${formatdate("YYYY-MM-DD-hhmm", timestamp())}"
  delete_automated_backups     = var.delete_automated_backups

  multi_az               = var.multi_az
  deletion_protection    = var.deletion_protection
  iam_database_authentication_enabled = var.iam_database_authentication_enabled

  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  monitoring_interval             = var.monitoring_interval
  monitoring_role_arn             = var.monitoring_role_arn

  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_kms_key_id       = var.performance_insights_kms_key_id
  performance_insights_retention_period = var.performance_insights_retention_period

  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  apply_immediately          = var.apply_immediately
  allow_major_version_upgrade = var.allow_major_version_upgrade

  parameter_group_name = var.parameter_group_name
  option_group_name    = var.option_group_name

  ca_cert_identifier = var.ca_cert_identifier
  
  dynamic "restore_to_point_in_time" {
    for_each = var.restore_to_point_in_time != null ? [var.restore_to_point_in_time] : []
    content {
      source_db_instance_identifier = lookup(restore_to_point_in_time.value, "source_db_instance_identifier", null)
      source_dbi_resource_id        = lookup(restore_to_point_in_time.value, "source_dbi_resource_id", null)
      restore_time                  = lookup(restore_to_point_in_time.value, "restore_time", null)
      use_latest_restorable_time    = lookup(restore_to_point_in_time.value, "use_latest_restorable_time", null)
    }
  }

  tags = merge(
    var.tags,
    {
      Name   = var.identifier
      Engine = "mysql"
    }
  )

  lifecycle {
    ignore_changes = [final_snapshot_identifier]
  }
}

# Read Replica
resource "aws_db_instance" "replica" {
  count = var.create_read_replica ? var.read_replica_count : 0

  identifier              = "${var.identifier}-replica-${count.index + 1}"
  replicate_source_db     = aws_db_instance.this.identifier
  instance_class          = var.replica_instance_class != null ? var.replica_instance_class : var.instance_class
  storage_encrypted       = var.storage_encrypted
  kms_key_id              = var.kms_key_id
  publicly_accessible     = var.publicly_accessible
  availability_zone       = var.replica_availability_zones != [] ? var.replica_availability_zones[count.index] : null
  
  vpc_security_group_ids = var.vpc_security_group_ids
  
  monitoring_interval = var.monitoring_interval
  monitoring_role_arn = var.monitoring_role_arn

  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_kms_key_id       = var.performance_insights_kms_key_id
  performance_insights_retention_period = var.performance_insights_retention_period

  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  apply_immediately          = var.apply_immediately

  skip_final_snapshot = true

  tags = merge(
    var.tags,
    {
      Name   = "${var.identifier}-replica-${count.index + 1}"
      Type   = "read-replica"
      Engine = "mysql"
    }
  )
}
