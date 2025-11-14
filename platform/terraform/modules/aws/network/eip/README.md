# Elastic IP Module

Creates AWS Elastic IP addresses for static public IPs.

## Usage

```hcl
module "nat_eips" {
  source = "../../modules/aws/network/eip"

  name      = "nat-gateway"
  eip_count = 3

  tags = {
    Purpose = "NAT Gateway"
  }
}
```