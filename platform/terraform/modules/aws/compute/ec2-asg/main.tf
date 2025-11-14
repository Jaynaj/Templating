resource "aws_autoscaling_group" "this" {
  name                      = var.name
  min_size                  = var.min_size
  max_size                  = var.max_size
  desired_capacity          = var.desired_capacity
  capacity_rebalance        = var.capacity_rebalance
  default_cooldown          = var.default_cooldown
  health_check_grace_period = var.health_check_grace_period
  health_check_type         = var.health_check_type
  force_delete              = var.force_delete
  termination_policies      = var.termination_policies
  suspended_processes       = var.suspended_processes
  enabled_metrics           = var.enabled_metrics
  metrics_granularity       = var.metrics_granularity
  wait_for_capacity_timeout = var.wait_for_capacity_timeout
  protect_from_scale_in     = var.protect_from_scale_in
  service_linked_role_arn   = var.service_linked_role_arn

  vpc_zone_identifier = var.subnet_ids

  dynamic "launch_template" {
    for_each = var.launch_template != null ? [var.launch_template] : []
    content {
      id      = lookup(launch_template.value, "id", null)
      name    = lookup(launch_template.value, "name", null)
      version = lookup(launch_template.value, "version", "$Latest")
    }
  }

  dynamic "mixed_instances_policy" {
    for_each = var.mixed_instances_policy != null ? [var.mixed_instances_policy] : []
    content {
      dynamic "instances_distribution" {
        for_each = lookup(mixed_instances_policy.value, "instances_distribution", null) != null ? [mixed_instances_policy.value.instances_distribution] : []
        content {
          on_demand_allocation_strategy            = lookup(instances_distribution.value, "on_demand_allocation_strategy", null)
          on_demand_base_capacity                  = lookup(instances_distribution.value, "on_demand_base_capacity", null)
          on_demand_percentage_above_base_capacity = lookup(instances_distribution.value, "on_demand_percentage_above_base_capacity", null)
          spot_allocation_strategy                 = lookup(instances_distribution.value, "spot_allocation_strategy", null)
          spot_instance_pools                      = lookup(instances_distribution.value, "spot_instance_pools", null)
          spot_max_price                           = lookup(instances_distribution.value, "spot_max_price", null)
        }
      }

      launch_template {
        launch_template_specification {
          launch_template_id = mixed_instances_policy.value.launch_template_id
          version            = lookup(mixed_instances_policy.value, "version", "$Latest")
        }

        dynamic "override" {
          for_each = lookup(mixed_instances_policy.value, "overrides", [])
          content {
            instance_type     = override.value.instance_type
            weighted_capacity = lookup(override.value, "weighted_capacity", null)

            dynamic "launch_template_specification" {
              for_each = lookup(override.value, "launch_template_specification", null) != null ? [override.value.launch_template_specification] : []
              content {
                launch_template_id = lookup(launch_template_specification.value, "launch_template_id", null)
                version            = lookup(launch_template_specification.value, "version", null)
              }
            }
          }
        }
      }
    }
  }

  dynamic "initial_lifecycle_hook" {
    for_each = var.initial_lifecycle_hooks
    content {
      name                 = initial_lifecycle_hook.value.name
      lifecycle_transition = initial_lifecycle_hook.value.lifecycle_transition
      default_result       = lookup(initial_lifecycle_hook.value, "default_result", "ABANDON")
      heartbeat_timeout    = lookup(initial_lifecycle_hook.value, "heartbeat_timeout", 3600)
      notification_metadata = lookup(initial_lifecycle_hook.value, "notification_metadata", null)
      notification_target_arn = lookup(initial_lifecycle_hook.value, "notification_target_arn", null)
      role_arn             = lookup(initial_lifecycle_hook.value, "role_arn", null)
    }
  }

  dynamic "tag" {
    for_each = var.tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  dynamic "tag" {
    for_each = { Name = var.name }
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [desired_capacity, target_group_arns]
  }
}

# Target Group Attachment
resource "aws_autoscaling_attachment" "this" {
  for_each = toset(var.target_group_arns)

  autoscaling_group_name = aws_autoscaling_group.this.id
  lb_target_group_arn    = each.value
}

# Scaling Policies
resource "aws_autoscaling_policy" "this" {
  for_each = var.scaling_policies

  name                   = each.key
  autoscaling_group_name = aws_autoscaling_group.this.name
  policy_type            = lookup(each.value, "policy_type", "TargetTrackingScaling")
  adjustment_type        = lookup(each.value, "adjustment_type", null)
  scaling_adjustment     = lookup(each.value, "scaling_adjustment", null)
  cooldown               = lookup(each.value, "cooldown", null)
  estimated_instance_warmup = lookup(each.value, "estimated_instance_warmup", null)

  dynamic "target_tracking_configuration" {
    for_each = lookup(each.value, "target_tracking_configuration", null) != null ? [each.value.target_tracking_configuration] : []
    content {
      target_value     = target_tracking_configuration.value.target_value
      disable_scale_in = lookup(target_tracking_configuration.value, "disable_scale_in", false)

      dynamic "predefined_metric_specification" {
        for_each = lookup(target_tracking_configuration.value, "predefined_metric_specification", null) != null ? [target_tracking_configuration.value.predefined_metric_specification] : []
        content {
          predefined_metric_type = predefined_metric_specification.value.predefined_metric_type
          resource_label         = lookup(predefined_metric_specification.value, "resource_label", null)
        }
      }

      dynamic "customized_metric_specification" {
        for_each = lookup(target_tracking_configuration.value, "customized_metric_specification", null) != null ? [target_tracking_configuration.value.customized_metric_specification] : []
        content {
          metric_name = customized_metric_specification.value.metric_name
          namespace   = customized_metric_specification.value.namespace
          statistic   = customized_metric_specification.value.statistic
          unit        = lookup(customized_metric_specification.value, "unit", null)

          dynamic "metric_dimension" {
            for_each = lookup(customized_metric_specification.value, "metric_dimensions", [])
            content {
              name  = metric_dimension.value.name
              value = metric_dimension.value.value
            }
          }
        }
      }
    }
  }

  dynamic "step_scaling_policy_configuration" {
    for_each = lookup(each.value, "step_scaling_policy_configuration", null) != null ? [each.value.step_scaling_policy_configuration] : []
    content {
      adjustment_type          = step_scaling_policy_configuration.value.adjustment_type
      cooldown                 = lookup(step_scaling_policy_configuration.value, "cooldown", null)
      metric_aggregation_type  = lookup(step_scaling_policy_configuration.value, "metric_aggregation_type", "Average")
      min_adjustment_magnitude = lookup(step_scaling_policy_configuration.value, "min_adjustment_magnitude", null)

      dynamic "step_adjustment" {
        for_each = lookup(step_scaling_policy_configuration.value, "step_adjustments", [])
        content {
          scaling_adjustment          = step_adjustment.value.scaling_adjustment
          metric_interval_lower_bound = lookup(step_adjustment.value, "metric_interval_lower_bound", null)
          metric_interval_upper_bound = lookup(step_adjustment.value, "metric_interval_upper_bound", null)
        }
      }
    }
  }
}

# Scheduled Actions
resource "aws_autoscaling_schedule" "this" {
  for_each = var.scheduled_actions

  scheduled_action_name  = each.key
  autoscaling_group_name = aws_autoscaling_group.this.name
  min_size               = lookup(each.value, "min_size", null)
  max_size               = lookup(each.value, "max_size", null)
  desired_capacity       = lookup(each.value, "desired_capacity", null)
  start_time             = lookup(each.value, "start_time", null)
  end_time               = lookup(each.value, "end_time", null)
  recurrence             = lookup(each.value, "recurrence", null)
  time_zone              = lookup(each.value, "time_zone", null)
}
