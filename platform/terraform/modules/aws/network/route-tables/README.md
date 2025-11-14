# Route Tables Module

Creates AWS Route Tables with flexible route configuration and subnet associations.

## Usage

```hcl
module "private_route_table" {
  source = "../../modules/aws/network/route-tables"

  name   = "private-rt"
  vpc_id = module.vpc.vpc_id

  routes = [
    {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = module.nat_gateway.nat_gateway_ids[0]
    }
  ]

  subnet_ids = module.subnets.private_subnet_ids

  tags = {
    Environment = "production"
  }
}
```