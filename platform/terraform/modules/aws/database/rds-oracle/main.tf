resource "aws_db_instance" "this" {
  identifier     = var.identifier
  engine         = "oracle-${var.engine_edition}"
  engine_version = var.engine_version
  license_model  = var.license_model

  # Instance configuration
  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage
  storage_type      = var.storage_type
  iops              = var.iops
  storage_encrypted = var.storage_encrypted
  kms_key_id        = var.kms_key_id

  # Database configuration
  db_name  = var.db_name
  username = var.master_username
  password = var.master_password
  port     = var.port

  # Network configuration
  db_subnet_group_name   = var.db_subnet_group_name
  vpc_security_group_ids = var.vpc_security_group_ids
  publicly_accessible    = var.publicly_accessible

  # High availability
  multi_az               = var.multi_az
  availability_zone      = var.multi_az ? null : var.availability_zone

  # Backup configuration
  backup_retention_period   = var.backup_retention_period
  backup_window             = var.backup_window
  maintenance_window        = var.maintenance_window
  copy_tags_to_snapshot     = var.copy_tags_to_snapshot
  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = var.skip_final_snapshot ? null : "${var.identifier}-final-snapshot"

  # Monitoring
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  monitoring_interval             = var.monitoring_interval
  monitoring_role_arn             = var.monitoring_interval > 0 ? var.monitoring_role_arn : null
  performance_insights_enabled    = var.performance_insights_enabled
  performance_insights_kms_key_id = var.performance_insights_kms_key_id
  performance_insights_retention_period = var.performance_insights_retention_period

  # Oracle specific
  character_set_name = var.character_set_name
  nchar_character_set_name = var.nchar_character_set_name
  timezone = var.timezone
  
  # Options and parameters
  option_group_name    = var.option_group_name != null ? var.option_group_name : aws_db_option_group.this[0].name
  parameter_group_name = var.parameter_group_name != null ? var.parameter_group_name : aws_db_parameter_group.this[0].name

  # Deletion protection
  deletion_protection = var.deletion_protection

  # Auto minor version upgrade
  auto_minor_version_upgrade = var.auto_minor_version_upgrade

  # Allow major version upgrade
  allow_major_version_upgrade = var.allow_major_version_upgrade

  # Apply changes immediately
  apply_immediately = var.apply_immediately

  tags = merge(
    var.tags,
    {
      Name   = var.identifier
      Engine = "oracle-${var.engine_edition}"
    }
  )
}

# Default option group
resource "aws_db_option_group" "this" {
  count = var.option_group_name == null ? 1 : 0

  name                     = "${var.identifier}-options"
  option_group_description = "Option group for ${var.identifier}"
  engine_name              = "oracle-${var.engine_edition}"
  major_engine_version     = var.major_engine_version

  dynamic "option" {
    for_each = var.options
    content {
      option_name = option.value.option_name
      port        = lookup(option.value, "port", null)
      version     = lookup(option.value, "version", null)
      db_security_group_memberships  = lookup(option.value, "db_security_group_memberships", null)
      vpc_security_group_memberships = lookup(option.value, "vpc_security_group_memberships", null)

      dynamic "option_settings" {
        for_each = lookup(option.value, "option_settings", [])
        content {
          name  = option_settings.value.name
          value = option_settings.value.value
        }
      }
    }
  }

  tags = var.tags
}

# Default parameter group
resource "aws_db_parameter_group" "this" {
  count = var.parameter_group_name == null ? 1 : 0

  name        = "${var.identifier}-params"
  family      = var.parameter_group_family
  description = "Parameter group for ${var.identifier}"

  dynamic "parameter" {
    for_each = var.parameters
    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = lookup(parameter.value, "apply_method", "immediate")
    }
  }

  tags = var.tags
}

# Read replica
resource "aws_db_instance" "replica" {
  count = var.create_read_replica ? var.read_replica_count : 0

  identifier          = "${var.identifier}-replica-${count.index + 1}"
  replicate_source_db = aws_db_instance.this.identifier

  # Instance configuration
  instance_class = var.replica_instance_class != null ? var.replica_instance_class : var.instance_class
  storage_type   = var.storage_type
  iops           = var.iops

  # Network (can be in different region/AZ)
  availability_zone      = length(var.replica_availability_zones) > count.index ? var.replica_availability_zones[count.index] : null
  publicly_accessible    = var.publicly_accessible
  vpc_security_group_ids = var.vpc_security_group_ids

  # Monitoring
  monitoring_interval             = var.monitoring_interval
  monitoring_role_arn             = var.monitoring_interval > 0 ? var.monitoring_role_arn : null
  performance_insights_enabled    = var.performance_insights_enabled
  performance_insights_kms_key_id = var.performance_insights_kms_key_id

  # Auto minor version upgrade
  auto_minor_version_upgrade = var.auto_minor_version_upgrade

  # Apply changes immediately
  apply_immediately = var.apply_immediately

  tags = merge(
    var.tags,
    {
      Name   = "${var.identifier}-replica-${count.index + 1}"
      Type   = "read-replica"
    }
  )
}
