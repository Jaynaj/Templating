# EC2 Auto Scaling Group Module

This module creates an AWS Auto Scaling Group with support for mixed instances policies, scaling policies, scheduled actions, and lifecycle hooks.

## Features

- Auto Scaling Group with configurable min/max/desired capacity
- Mixed instances policy (On-Demand + Spot)
- Multiple scaling policies (target tracking, step, simple)
- Scheduled scaling actions
- Lifecycle hooks for custom actions
- Target group attachment for load balancers
- Comprehensive CloudWatch metrics
- Instance protection options
- Capacity rebalancing for Spot instances

## Usage

### Basic Auto Scaling Group

```hcl
module "asg" {
  source = "../../modules/aws/compute/ec2-asg"

  name = "web-asg"

  min_size         = 2
  max_size         = 10
  desired_capacity = 3

  health_check_type         = "ELB"
  health_check_grace_period = 300

  subnet_ids = module.vpc.private_subnets

  launch_template = {
    id      = module.launch_template.launch_template_id
    version = "$Latest"
  }

  target_group_arns = [
    aws_lb_target_group.web.arn
  ]

  scaling_policies = {
    cpu_target_tracking = {
      policy_type = "TargetTrackingScaling"
      target_tracking_configuration = {
        predefined_metric_specification = {
          predefined_metric_type = "ASGAverageCPUUtilization"
        }
        target_value = 70.0
      }
    }
  }

  tags = {
    Environment = "production"
    Application = "web"
  }
}
```

### Mixed Instances Policy (On-Demand + Spot)

```hcl
module "asg_mixed" {
  source = "../../modules/aws/compute/ec2-asg"

  name = "mixed-asg"

  min_size         = 2
  max_size         = 20
  desired_capacity = 4

  subnet_ids = module.vpc.private_subnets

  mixed_instances_policy = {
    launch_template_id = module.launch_template.launch_template_id
    version            = "$Latest"

    instances_distribution = {
      on_demand_base_capacity                  = 2
      on_demand_percentage_above_base_capacity = 20
      spot_allocation_strategy                 = "capacity-optimized"
      spot_instance_pools                      = 4
    }

    overrides = [
      { instance_type = "t3.large" },
      { instance_type = "t3a.large" },
      { instance_type = "t2.large" }
    ]
  }

  capacity_rebalance = true

  scaling_policies = {
    requests_target_tracking = {
      policy_type = "TargetTrackingScaling"
      target_tracking_configuration = {
        predefined_metric_specification = {
          predefined_metric_type = "ALBRequestCountPerTarget"
          resource_label         = "${aws_lb.main.arn_suffix}/${aws_lb_target_group.main.arn_suffix}"
        }
        target_value = 1000.0
      }
    }
  }

  tags = {
    Environment = "production"
    CostOptimized = "true"
  }
}
```

### Scheduled Scaling

```hcl
module "asg_scheduled" {
  source = "../../modules/aws/compute/ec2-asg"

  name = "scheduled-asg"

  min_size         = 1
  max_size         = 10
  desired_capacity = 2

  subnet_ids = module.vpc.private_subnets

  launch_template = {
    id      = module.launch_template.launch_template_id
    version = "$Latest"
  }

  # Scale up during business hours
  scheduled_actions = {
    scale_up_morning = {
      min_size         = 5
      max_size         = 10
      desired_capacity = 5
      recurrence       = "0 8 * * MON-FRI"
      time_zone        = "America/New_York"
    }
    scale_down_evening = {
      min_size         = 1
      max_size         = 3
      desired_capacity = 1
      recurrence       = "0 18 * * MON-FRI"
      time_zone        = "America/New_York"
    }
  }

  tags = {
    Environment = "production"
  }
}
```

### Lifecycle Hooks

```hcl
module "asg_lifecycle" {
  source = "../../modules/aws/compute/ec2-asg"

  name = "asg-with-hooks"

  min_size         = 2
  max_size         = 6
  desired_capacity = 3

  subnet_ids = module.vpc.private_subnets

  launch_template = {
    id      = module.launch_template.launch_template_id
    version = "$Latest"
  }

  initial_lifecycle_hooks = [
    {
      name                  = "instance-launching"
      lifecycle_transition  = "autoscaling:EC2_INSTANCE_LAUNCHING"
      default_result        = "CONTINUE"
      heartbeat_timeout     = 300
      notification_target_arn = aws_sns_topic.asg_events.arn
      role_arn              = aws_iam_role.asg_lifecycle.arn
    },
    {
      name                  = "instance-terminating"
      lifecycle_transition  = "autoscaling:EC2_INSTANCE_TERMINATING"
      default_result        = "CONTINUE"
      heartbeat_timeout     = 300
      notification_target_arn = aws_sns_topic.asg_events.arn
      role_arn              = aws_iam_role.asg_lifecycle.arn
    }
  ]

  tags = {
    Environment = "production"
  }
}
```

## Scaling Policies

### Target Tracking Policies

- **ASGAverageCPUUtilization**: Track average CPU utilization
- **ASGAverageNetworkIn**: Track average network input
- **ASGAverageNetworkOut**: Track average network output
- **ALBRequestCountPerTarget**: Track ALB request count per target

### Termination Policies

- **Default**: Balanced across AZs, oldest launch template, closest to billing hour
- **OldestInstance**: Terminate oldest instances first
- **NewestInstance**: Terminate newest instances first
- **OldestLaunchTemplate**: Terminate instances with oldest launch template
- **AllocationStrategy**: For Spot, terminate based on allocation strategy

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 4.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name of the Auto Scaling Group | `string` | n/a | yes |
| min_size | Minimum size | `number` | `1` | no |
| max_size | Maximum size | `number` | `3` | no |
| desired_capacity | Desired capacity | `number` | `2` | no |
| subnet_ids | Subnet IDs | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| autoscaling_group_id | ID of the Auto Scaling Group |
| autoscaling_group_name | Name of the Auto Scaling Group |
| autoscaling_group_arn | ARN of the Auto Scaling Group |
| scaling_policy_arns | ARNs of scaling policies |
