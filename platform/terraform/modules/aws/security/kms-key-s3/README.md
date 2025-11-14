# Kms Key S3 Module

This module creates KMS key for S3.

## Usage

```hcl
module "kms_key_s3" {
  source = "../../modules/aws/category/kms-key-s3"

  name = "example"

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
| name | Name of the resource | `string` | n/a | yes |
| tags | Tags to apply to resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | ID of the created resource |
| arn | ARN of the created resource |
