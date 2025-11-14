# Subnet Set Module

Creates public, private, and optionally database subnets across multiple availability zones with automatic CIDR calculation.

## Features

- Automatic CIDR block calculation for subnets
- Public subnets with optional public IP mapping
- Private subnets for internal resources
- Optional database subnets with DB subnet group
- Consistent tagging across all subnets
- Multi-AZ support

## Usage

```hcl
module "subnets" {
  source = "../../modules/aws/network/subnet-set"

  name_prefix        = "production"
  vpc_id             = module.vpc.vpc_id
  vpc_cidr           = "10.0.0.0/16"
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]

  # Automatically creates:
  # Public: 10.0.0.0/24, 10.0.1.0/24, 10.0.2.0/24
  # Private: 10.0.3.0/24, 10.0.4.0/24, 10.0.5.0/24
  # Database: 10.0.6.0/24, 10.0.7.0/24, 10.0.8.0/24

  map_public_ip_on_launch = true
  create_database_subnets = true

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }
}
```

## Subnet Sizing

The `newbits` parameter controls subnet size:
- `newbits = 8`: /16 VPC → /24 subnets (256 IPs each)
- `newbits = 4`: /16 VPC → /20 subnets (4096 IPs each)
- `newbits = 2`: /16 VPC → /18 subnets (16384 IPs each)

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 4.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name_prefix | Prefix for subnet names | `string` | n/a | yes |
| vpc_id | VPC ID | `string` | n/a | yes |
| vpc_cidr | VPC CIDR block | `string` | n/a | yes |
| availability_zones | List of AZs | `list(string)` | n/a | yes |
| newbits | Additional bits for subnet CIDR | `number` | `8` | no |
| create_database_subnets | Create database subnets | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| public_subnet_ids | List of public subnet IDs |
| private_subnet_ids | List of private subnet IDs |
| database_subnet_ids | List of database subnet IDs |
| database_subnet_group_name | DB subnet group name |
