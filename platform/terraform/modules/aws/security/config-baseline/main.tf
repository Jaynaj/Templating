resource "aws_config_configuration_recorder" "this" {
  name     = var.name
  role_arn = var.iam_role_arn

  recording_group {
    all_supported                 = length(var.resource_types) == 0
    include_global_resource_types = var.include_global_resource_types
    resource_types                = length(var.resource_types) > 0 ? var.resource_types : null
  }
}

resource "aws_config_delivery_channel" "this" {
  name           = var.name
  s3_bucket_name = var.s3_bucket_name
  s3_key_prefix  = var.s3_key_prefix
  sns_topic_arn  = var.sns_topic_arn

  snapshot_delivery_properties {
    delivery_frequency = var.delivery_frequency
  }

  depends_on = [aws_config_configuration_recorder.this]
}

resource "aws_config_configuration_recorder_status" "this" {
  name       = aws_config_configuration_recorder.this.name
  is_enabled = true

  depends_on = [aws_config_delivery_channel.this]
}
