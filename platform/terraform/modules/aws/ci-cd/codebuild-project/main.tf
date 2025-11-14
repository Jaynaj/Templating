resource "aws_codebuild_project" "this" {
  name           = var.name
  description    = var.description
  service_role   = var.service_role
  build_timeout  = var.build_timeout
  queued_timeout = var.queued_timeout

  concurrent_build_limit = var.concurrent_build_limit

  artifacts {
    type      = var.artifacts.type
    location  = lookup(var.artifacts, "location", null)
    packaging = lookup(var.artifacts, "packaging", null)
    name      = lookup(var.artifacts, "name", null)
  }

  environment {
    compute_type                = var.environment.compute_type
    image                       = var.environment.image
    type                        = var.environment.type
    image_pull_credentials_type = lookup(var.environment, "image_pull_credentials_type", "CODEBUILD")
    privileged_mode             = lookup(var.environment, "privileged_mode", false)

    dynamic "environment_variable" {
      for_each = lookup(var.environment, "environment_variables", [])
      content {
        name  = environment_variable.value.name
        value = environment_variable.value.value
        type  = lookup(environment_variable.value, "type", "PLAINTEXT")
      }
    }
  }

  source {
    type            = var.source.type
    location        = lookup(var.source, "location", null)
    buildspec       = lookup(var.source, "buildspec", null)
    git_clone_depth = lookup(var.source, "git_clone_depth", null)

    dynamic "git_submodules_config" {
      for_each = lookup(var.source, "git_submodules_config", null) != null ? [var.source.git_submodules_config] : []
      content {
        fetch_submodules = git_submodules_config.value.fetch_submodules
      }
    }
  }

  dynamic "cache" {
    for_each = var.cache != null ? [var.cache] : []
    content {
      type     = cache.value.type
      location = lookup(cache.value, "location", null)
      modes    = lookup(cache.value, "modes", null)
    }
  }

  dynamic "logs_config" {
    for_each = var.logs_config != null ? [var.logs_config] : []
    content {
      dynamic "cloudwatch_logs" {
        for_each = lookup(logs_config.value, "cloudwatch_logs", null) != null ? [logs_config.value.cloudwatch_logs] : []
        content {
          status      = cloudwatch_logs.value.status
          group_name  = lookup(cloudwatch_logs.value, "group_name", null)
          stream_name = lookup(cloudwatch_logs.value, "stream_name", null)
        }
      }

      dynamic "s3_logs" {
        for_each = lookup(logs_config.value, "s3_logs", null) != null ? [logs_config.value.s3_logs] : []
        content {
          status              = s3_logs.value.status
          location            = lookup(s3_logs.value, "location", null)
          encryption_disabled = lookup(s3_logs.value, "encryption_disabled", false)
        }
      }
    }
  }

  dynamic "vpc_config" {
    for_each = var.vpc_config != null ? [var.vpc_config] : []
    content {
      vpc_id             = vpc_config.value.vpc_id
      subnets            = vpc_config.value.subnets
      security_group_ids = vpc_config.value.security_group_ids
    }
  }

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}
