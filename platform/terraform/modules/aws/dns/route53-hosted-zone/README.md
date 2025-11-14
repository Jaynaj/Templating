# Route53 Hosted Zone Module

This module creates Route53 hosted zone.

## Usage

```hcl
module "route53_hosted_zone" {
  source = "../../modules/aws/category/route53-hosted-zone"

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
