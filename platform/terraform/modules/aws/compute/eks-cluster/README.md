# EKS Cluster Module

This module creates an AWS EKS cluster with comprehensive configuration options including IRSA, add-ons, logging, and security.

## Features

- Kubernetes cluster with configurable version
- Private and public API endpoint configuration
- IAM Roles for Service Accounts (IRSA) support
- Control plane logging to CloudWatch
- Secrets encryption with KMS
- EKS add-ons management (VPC CNI, CoreDNS, kube-proxy, etc.)
- IPv4 and IPv6 support
- EKS on Outposts support
- Comprehensive tagging

## Usage

```hcl
module "eks_cluster" {
  source = "../../modules/aws/compute/eks-cluster"

  cluster_name    = "production-eks"
  cluster_version = "1.28"

  cluster_role_arn = aws_iam_role.eks_cluster.arn
  vpc_id           = module.vpc.vpc_id
  subnet_ids       = module.vpc.private_subnets

  endpoint_private_access = true
  endpoint_public_access  = true
  public_access_cidrs     = ["10.0.0.0/8"]

  # Enable all control plane logs
  cluster_enabled_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]

  # Encrypt secrets at rest
  cluster_encryption_config = [
    {
      provider_key_arn = aws_kms_key.eks.arn
      resources        = ["secrets"]
    }
  ]

  # Enable IRSA
  enable_irsa = true

  # Install essential add-ons
  cluster_addons = {
    vpc-cni = {
      addon_version     = "v1.15.0-eksbuild.2"
      resolve_conflicts = "OVERWRITE"
    }
    coredns = {
      addon_version     = "v1.10.1-eksbuild.2"
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {
      addon_version     = "v1.28.1-eksbuild.1"
      resolve_conflicts = "OVERWRITE"
    }
    aws-ebs-csi-driver = {
      addon_version            = "v1.24.0-eksbuild.1"
      service_account_role_arn = aws_iam_role.ebs_csi_driver.arn
      resolve_conflicts        = "OVERWRITE"
    }
  }

  cloudwatch_log_group_retention_in_days = 7
  cloudwatch_log_group_kms_key_id        = aws_kms_key.cloudwatch.arn

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }
}
```

## Common Add-ons

| Add-on | Purpose |
|--------|---------|
| vpc-cni | Amazon VPC CNI plugin for pod networking |
| coredns | DNS service discovery |
| kube-proxy | Network proxy on each node |
| aws-ebs-csi-driver | EBS volume provisioning |
| aws-efs-csi-driver | EFS volume provisioning |
| amazon-cloudwatch-observability | CloudWatch monitoring |
| adot | AWS Distro for OpenTelemetry |

## Control Plane Logging

Available log types:
- **api**: API server logs
- **audit**: Audit logs
- **authenticator**: Authentication logs
- **controllerManager**: Controller manager logs
- **scheduler**: Scheduler logs

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster_name | Name of the EKS cluster | `string` | n/a | yes |
| cluster_version | Kubernetes version | `string` | `"1.28"` | no |
| cluster_role_arn | IAM role ARN for the cluster | `string` | n/a | yes |
| vpc_id | VPC ID | `string` | n/a | yes |
| subnet_ids | Subnet IDs for the cluster | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| cluster_id | EKS cluster ID |
| cluster_arn | EKS cluster ARN |
| cluster_endpoint | API server endpoint |
| oidc_provider_arn | OIDC provider ARN for IRSA |
| cluster_certificate_authority_data | CA certificate data |
