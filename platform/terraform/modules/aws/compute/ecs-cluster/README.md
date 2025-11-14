# ECS Cluster Module

This module creates an AWS ECS cluster with support for Container Insights, capacity providers, and ECS Exec.

## Features

- CloudWatch Container Insights support
- Capacity provider configuration (Fargate, Fargate Spot, EC2)
- ECS Exec (execute command) support with encryption
- CloudWatch log group for centralized logging
- Configurable log retention

## Usage

```hcl
module "ecs_cluster" {
  source = "../../modules/aws/compute/ecs-cluster"

  cluster_name               = "production-cluster"
  container_insights_enabled = true
  enable_execute_command     = true

  capacity_providers = ["FARGATE", "FARGATE_SPOT"]

  default_capacity_provider_strategy = [
    {
      capacity_provider = "FARGATE_SPOT"
      weight            = 1
      base              = 0
    }
  ]

  log_retention_in_days = 7

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
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
| cluster_name | Name of the ECS cluster | `string` | n/a | yes |
| container_insights_enabled | Enable CloudWatch Container Insights | `bool` | `true` | no |
| enable_execute_command | Enable ECS Exec for debugging | `bool` | `false` | no |
| capacity_providers | List of capacity providers | `list(string)` | `["FARGATE", "FARGATE_SPOT"]` | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster_id | ID of the ECS cluster |
| cluster_arn | ARN of the ECS cluster |
| cluster_name | Name of the ECS cluster |
| cloudwatch_log_group_name | Name of the CloudWatch log group |
