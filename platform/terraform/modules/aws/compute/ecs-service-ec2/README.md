# ECS Service (EC2) Module

This module creates an AWS ECS service running on EC2 instances with support for various network modes, placement strategies, and deployment configurations.

## Features

- EC2 launch type with flexible network modes (bridge, host, awsvpc)
- Capacity provider support for auto-scaling
- Advanced placement strategies (spread, binpack, random)
- Placement constraints for task scheduling
- Load balancer integration (ALB/NLB)
- Service discovery (AWS Cloud Map)
- Docker and EFS volume support
- Deployment circuit breaker with rollback
- ECS Exec support

## Usage

```hcl
module "ecs_service_ec2" {
  source = "../../modules/aws/compute/ecs-service-ec2"

  service_name = "backend-service"
  cluster_id   = module.ecs_cluster.cluster_id
  task_family  = "backend-task"

  network_mode = "bridge"

  container_definitions = jsonencode([
    {
      name      = "backend"
      image     = "myapp:latest"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 0
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/backend"
          "awslogs-region"        = "us-east-1"
          "awslogs-stream-prefix" = "backend"
        }
      }
    }
  ])

  execution_role_arn = aws_iam_role.ecs_execution.arn
  task_role_arn      = aws_iam_role.ecs_task.arn

  desired_count = 3

  # Placement strategy: spread across AZs and instances
  ordered_placement_strategy = [
    {
      type  = "spread"
      field = "attribute:ecs.availability-zone"
    },
    {
      type  = "spread"
      field = "instanceId"
    }
  ]

  # Only run on instances with specific attributes
  placement_constraints = [
    {
      type       = "memberOf"
      expression = "attribute:ecs.instance-type =~ t3.*"
    }
  ]

  load_balancer_config = {
    target_group_arn = aws_lb_target_group.backend.arn
    container_name   = "backend"
    container_port   = 8080
  }

  tags = {
    Environment = "production"
    Service     = "backend"
  }
}
```

## Network Modes

- **bridge**: Default Docker bridge network (dynamic port mapping)
- **host**: Use host's network stack directly
- **awsvpc**: Task gets its own ENI (requires subnets and security groups)
- **none**: No networking

## Placement Strategies

- **spread**: Distribute tasks evenly (by AZ, instance, custom attribute)
- **binpack**: Pack tasks to minimize number of instances (CPU or memory)
- **random**: Random placement

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 4.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| service_name | Name of the ECS service | `string` | n/a | yes |
| cluster_id | ECS cluster ID | `string` | n/a | yes |
| task_family | Task definition family name | `string` | n/a | yes |
| network_mode | Network mode for tasks | `string` | `"bridge"` | no |

## Outputs

| Name | Description |
|------|-------------|
| service_id | ID of the ECS service |
| service_name | Name of the ECS service |
| task_definition_arn | ARN of the task definition |
