# EKS Node Group Module

This module creates an AWS EKS managed node group with support for various configurations including spot instances, taints, labels, and custom launch templates.

## Features

- Managed node group with auto-scaling
- Support for both ON_DEMAND and SPOT capacity
- Multiple instance types support
- Custom launch template integration
- SSH access configuration
- Kubernetes taints and labels
- Multiple AMI types (Amazon Linux 2, Bottlerocket, GPU-optimized)
- Multi-architecture support (x86_64, ARM64)

## Usage

```hcl
module "eks_node_group" {
  source = "../../modules/aws/compute/eks-node-group"

  cluster_name      = module.eks_cluster.cluster_name
  node_group_name   = "general-purpose"
  node_role_arn     = aws_iam_role.eks_node_group.arn
  subnet_ids        = module.vpc.private_subnets
  kubernetes_version = "1.28"

  desired_size = 3
  max_size     = 6
  min_size     = 2

  ami_type       = "AL2_x86_64"
  capacity_type  = "ON_DEMAND"
  disk_size      = 50
  instance_types = ["t3.large", "t3a.large"]

  labels = {
    workload-type = "general"
    environment   = "production"
  }

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

# Spot instance node group example
module "eks_spot_node_group" {
  source = "../../modules/aws/compute/eks-node-group"

  cluster_name    = module.eks_cluster.cluster_name
  node_group_name = "spot-workers"
  node_role_arn   = aws_iam_role.eks_node_group.arn
  subnet_ids      = module.vpc.private_subnets

  desired_size = 2
  max_size     = 10
  min_size     = 0

  capacity_type  = "SPOT"
  instance_types = ["t3.large", "t3a.large", "t2.large"]

  labels = {
    workload-type = "batch"
    capacity-type = "spot"
  }

  taints = [
    {
      key    = "spot"
      value  = "true"
      effect = "NoSchedule"
    }
  ]

  tags = {
    Environment = "production"
    NodeType    = "spot"
  }
}
```

## AMI Types

| AMI Type | Description |
|----------|-------------|
| AL2_x86_64 | Amazon Linux 2 (x86_64) |
| AL2_x86_64_GPU | Amazon Linux 2 with GPU support |
| AL2_ARM_64 | Amazon Linux 2 (ARM64/Graviton) |
| BOTTLEROCKET_x86_64 | Bottlerocket (x86_64) |
| BOTTLEROCKET_ARM_64 | Bottlerocket (ARM64/Graviton) |

## Taint Effects

- **NoSchedule**: New pods won't be scheduled unless they tolerate the taint
- **PreferNoSchedule**: Kubernetes tries to avoid scheduling pods without toleration
- **NoExecute**: Existing pods without toleration will be evicted

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster_name | Name of the EKS cluster | `string` | n/a | yes |
| node_group_name | Name of the node group | `string` | n/a | yes |
| node_role_arn | IAM role ARN for nodes | `string` | n/a | yes |
| subnet_ids | Subnet IDs for nodes | `list(string)` | n/a | yes |
| capacity_type | Capacity type (ON_DEMAND or SPOT) | `string` | `"ON_DEMAND"` | no |

## Outputs

| Name | Description |
|------|-------------|
| node_group_id | EKS node group ID |
| node_group_arn | ARN of the node group |
| node_group_status | Status of the node group |
