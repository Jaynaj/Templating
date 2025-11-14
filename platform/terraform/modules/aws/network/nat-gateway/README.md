# NAT Gateway Module

Creates AWS NAT Gateways with Elastic IPs for private subnet internet access.

## Features

- Multiple NAT Gateways (typically one per AZ for high availability)
- Automatic Elastic IP creation
- Support for existing EIPs
- Public or private connectivity type
- Proper dependency handling with IGW

## Usage

```hcl
# Single NAT Gateway (cost-optimized)
module "nat_gateway_single" {
  source = "../../modules/aws/network/nat-gateway"

  name              = "production"
  nat_gateway_count = 1
  subnet_ids        = [module.subnets.public_subnet_ids[0]]
  
  internet_gateway_id = module.vpc.internet_gateway_id

  tags = {
    Environment = "production"
  }
}

# Highly Available NAT Gateways (one per AZ)
module "nat_gateway_ha" {
  source = "../../modules/aws/network/nat-gateway"

  name              = "production"
  nat_gateway_count = 3
  subnet_ids        = module.subnets.public_subnet_ids
  
  internet_gateway_id = module.vpc.internet_gateway_id

  tags = {
    Environment = "production"
    HA          = "true"
  }
}
```

## Cost Optimization

NAT Gateway pricing:
- **Hourly**: ~$0.045/hour per NAT Gateway
- **Data**: $0.045/GB processed

Options:
- **Single NAT Gateway**: Lower cost, single point of failure
- **Multi-AZ**: Higher availability, higher cost
- **Alternative**: NAT Instances for lower cost (requires more management)

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 4.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name prefix | `string` | n/a | yes |
| nat_gateway_count | Number of NAT Gateways | `number` | `1` | no |
| subnet_ids | Public subnet IDs | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| nat_gateway_ids | NAT Gateway IDs |
| eip_public_ips | Elastic IP addresses |
