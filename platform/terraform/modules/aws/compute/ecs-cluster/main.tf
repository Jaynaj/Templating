resource "aws_ecs_cluster" "this" {
  name = var.cluster_name

  setting {
    name  = "containerInsights"
    value = var.container_insights_enabled ? "enabled" : "disabled"
  }

  dynamic "configuration" {
    for_each = var.enable_execute_command ? [1] : []
    content {
      execute_command_configuration {
        kms_key_id = var.kms_key_id
        logging    = var.execute_command_logging

        dynamic "log_configuration" {
          for_each = var.execute_command_log_configuration != null ? [var.execute_command_log_configuration] : []
          content {
            cloud_watch_encryption_enabled = lookup(log_configuration.value, "cloud_watch_encryption_enabled", null)
            cloud_watch_log_group_name     = lookup(log_configuration.value, "cloud_watch_log_group_name", null)
            s3_bucket_name                 = lookup(log_configuration.value, "s3_bucket_name", null)
            s3_bucket_encryption_enabled   = lookup(log_configuration.value, "s3_bucket_encryption_enabled", null)
            s3_key_prefix                  = lookup(log_configuration.value, "s3_key_prefix", null)
          }
        }
      }
    }
  }

  tags = merge(
    var.tags,
    {
      Name = var.cluster_name
    }
  )
}

resource "aws_ecs_cluster_capacity_providers" "this" {
  count = length(var.capacity_providers) > 0 ? 1 : 0

  cluster_name       = aws_ecs_cluster.this.name
  capacity_providers = var.capacity_providers

  dynamic "default_capacity_provider_strategy" {
    for_each = var.default_capacity_provider_strategy
    content {
      capacity_provider = default_capacity_provider_strategy.value.capacity_provider
      weight            = lookup(default_capacity_provider_strategy.value, "weight", null)
      base              = lookup(default_capacity_provider_strategy.value, "base", null)
    }
  }
}

# CloudWatch Log Group for Container Insights
resource "aws_cloudwatch_log_group" "this" {
  count = var.container_insights_enabled && var.create_cloudwatch_log_group ? 1 : 0

  name              = "/aws/ecs/cluster/${var.cluster_name}"
  retention_in_days = var.log_retention_in_days
  kms_key_id        = var.kms_key_id

  tags = merge(
    var.tags,
    {
      Name = "/aws/ecs/cluster/${var.cluster_name}"
    }
  )
}
