resource "aws_codedeploy_app" "this" {
  name             = var.app_name
  compute_platform = "ECS"

  tags = merge(
    var.tags,
    {
      Name = var.app_name
    }
  )
}

resource "aws_codedeploy_deployment_group" "this" {
  app_name               = aws_codedeploy_app.this.name
  deployment_group_name  = var.name
  service_role_arn       = var.service_role_arn
  deployment_config_name = var.deployment_config_name

  auto_rollback_configuration {
    enabled = var.auto_rollback_enabled
    events  = var.auto_rollback_events
  }

  blue_green_deployment_config {
    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = var.termination_wait_time_in_minutes
    }

    dynamic "deployment_ready_option" {
      for_each = var.deployment_ready_option != null ? [var.deployment_ready_option] : []
      content {
        action_on_timeout    = lookup(deployment_ready_option.value, "action_on_timeout", "CONTINUE_DEPLOYMENT")
        wait_time_in_minutes = lookup(deployment_ready_option.value, "wait_time_in_minutes", null)
      }
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  ecs_service {
    cluster_name = var.ecs_cluster_name
    service_name = var.ecs_service_name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [var.production_listener_arn]
      }

      dynamic "test_traffic_route" {
        for_each = var.test_listener_arn != null ? [var.test_listener_arn] : []
        content {
          listener_arns = [test_traffic_route.value]
        }
      }

      target_group {
        name = var.target_group_names.blue
      }

      target_group {
        name = var.target_group_names.green
      }
    }
  }

  dynamic "alarm_configuration" {
    for_each = var.alarm_configuration.enabled ? [var.alarm_configuration] : []
    content {
      enabled = true
      alarms  = lookup(alarm_configuration.value, "alarms", [])
    }
  }

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}
