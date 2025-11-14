# ECS Service (Fargate) Module

This module creates an AWS ECS service running on Fargate with support for load balancers, service discovery, and deployment configurations.

## Features

- Fargate launch type with configurable CPU/memory
- Support for Fargate and Fargate Spot capacity providers
- Load balancer integration (ALB/NLB)
- Service discovery (AWS Cloud Map)
- ECS Exec support for debugging
- Deployment circuit breaker with automatic rollback
- EFS volume support
- Multi-architecture support (x86_64, ARM64)

## Usage

```hcl
module "ecs_service" {
  source = "../../modules/aws/compute/ecs-service-fargate"

  service_name = "web-service"
  cluster_id   = module.ecs_cluster.cluster_id
  task_family  = "web-task"

  cpu    = "512"
  memory = "1024"

  container_definitions = jsonencode([
    {
      name  = "web"
      image = "nginx:latest"
      portMappings = [
        {
          containerPort = 80
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/web-service"
          "awslogs-region"        = "us-east-1"
          "awslogs-stream-prefix" = "web"
        }
      }
    }
  ])

  execution_role_arn = aws_iam_role.ecs_execution.arn
  task_role_arn      = aws_iam_role.ecs_task.arn

  desired_count    = 2
  subnets          = module.vpc.private_subnets
  security_groups  = [aws_security_group.ecs_service.id]
  assign_public_ip = false

  load_balancer_config = {
    target_group_arn = aws_lb_target_group.web.arn
    container_name   = "web"
    container_port   = 80
  }

  capacity_provider_strategy = [
    {
      capacity_provider = "FARGATE_SPOT"
      weight            = 4
      base              = 0
    },
    {
      capacity_provider = "FARGATE"
      weight            = 1
      base              = 1
    }
  ]

  tags = {
    Environment = "production"
    Service     = "web"
  }
}
```

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
| cpu | CPU units for the task | `string` | `"256"` | no |
| memory | Memory for the task in MiB | `string` | `"512"` | no |

## Outputs

| Name | Description |
|------|-------------|
| service_id | ID of the ECS service |
| service_name | Name of the ECS service |
| task_definition_arn | ARN of the task definition |
