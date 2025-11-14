# S3 Bucket for Logs Module

Creates an S3 bucket optimized for storing logs from ALB, CloudFront, CloudTrail, VPC Flow Logs, and other AWS services.

## Features

- **Lifecycle Management**: Automatic transition to cheaper storage classes and expiration
- **Security**: Encryption, public access blocking, secure transport enforcement
- **Cost Optimization**: Intelligent tiering and automated transitions
- **Compliance**: Optional object lock for regulatory requirements
- **Integration**: Pre-configured policies for ALB, CloudFront, CloudTrail

## Usage

```hcl
module "log_bucket" {
  source = "../../modules/aws/storage/s3-bucket-logs"

  bucket_name = "my-app-logs"

  # Lifecycle management
  transition_to_ia_days          = 30   # Move to IA after 30 days
  transition_to_glacier_days     = 90   # Move to Glacier after 90 days
  transition_to_deep_archive_days = 180  # Move to Deep Archive after 180 days
  expiration_days                = 365  # Delete after 1 year

  # Allow ALB to write logs
  allow_elb_logging = true

  tags = {
    Environment = "production"
    Purpose     = "application-logs"
  }
}

# Use in ALB
resource "aws_lb" "main" {
  # ... other config ...

  access_logs {
    bucket  = module.log_bucket.bucket_id
    prefix  = "alb"
    enabled = true
  }
}
```

## Cost Optimization Example

Typical log storage costs with this module:
- Days 0-30: STANDARD (most expensive)
- Days 30-90: STANDARD_IA (50% cheaper)
- Days 90-180: GLACIER (80% cheaper)
- Days 180-365: DEEP_ARCHIVE (95% cheaper)
- Day 365+: Deleted

## Compliance Mode

```hcl
module "compliance_logs" {
  source = "../../modules/aws/storage/s3-bucket-logs"

  bucket_name = "audit-logs"

  # Object lock for compliance (immutable for 7 years)
  enable_object_lock = true
  object_lock_mode   = "COMPLIANCE"
  object_lock_days   = 2555  # 7 years

  # Longer retention
  expiration_days = 2555

  tags = {
    Compliance = "SOC2"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 4.0 |
