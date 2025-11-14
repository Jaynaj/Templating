locals {
  public_subnets = [
    for idx, az in var.availability_zones : {
      cidr = cidrsubnet(var.vpc_cidr, var.newbits, idx)
      az   = az
      name = "${var.name_prefix}-public-${az}"
    }
  ]

  private_subnets = [
    for idx, az in var.availability_zones : {
      cidr = cidrsubnet(var.vpc_cidr, var.newbits, idx + length(var.availability_zones))
      az   = az
      name = "${var.name_prefix}-private-${az}"
    }
  ]

  database_subnets = var.create_database_subnets ? [
    for idx, az in var.availability_zones : {
      cidr = cidrsubnet(var.vpc_cidr, var.newbits, idx + (2 * length(var.availability_zones)))
      az   = az
      name = "${var.name_prefix}-database-${az}"
    }
  ] : []
}

# Public Subnets
resource "aws_subnet" "public" {
  for_each = { for idx, subnet in local.public_subnets : idx => subnet }

  vpc_id                  = var.vpc_id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = merge(
    var.tags,
    {
      Name = each.value.name
      Type = "public"
      Tier = "public"
    }
  )
}

# Private Subnets
resource "aws_subnet" "private" {
  for_each = { for idx, subnet in local.private_subnets : idx => subnet }

  vpc_id            = var.vpc_id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = merge(
    var.tags,
    {
      Name = each.value.name
      Type = "private"
      Tier = "private"
    }
  )
}

# Database Subnets
resource "aws_subnet" "database" {
  for_each = { for idx, subnet in local.database_subnets : idx => subnet }

  vpc_id            = var.vpc_id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = merge(
    var.tags,
    {
      Name = each.value.name
      Type = "database"
      Tier = "database"
    }
  )
}

# Database Subnet Group
resource "aws_db_subnet_group" "this" {
  count = var.create_database_subnets && var.create_database_subnet_group ? 1 : 0

  name       = "${var.name_prefix}-db-subnet-group"
  subnet_ids = [for subnet in aws_subnet.database : subnet.id]

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-db-subnet-group"
    }
  )
}
