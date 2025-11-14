# DynamoDB Table Module

Creates AWS DynamoDB tables with support for GSI, LSI, streams, encryption, and auto-scaling.

## Features

- Pay-per-request or provisioned billing
- Global and local secondary indexes
- DynamoDB Streams
- Point-in-time recovery
- Server-side encryption with KMS
- Auto-scaling for provisioned capacity
- TTL support

## Usage

```hcl
module "users_table" {
  source = "../../modules/aws/database/dynamodb-table"

  name         = "users"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "userId"
  range_key    = "timestamp"

  attributes = [
    {
      name = "userId"
      type = "S"
    },
    {
      name = "timestamp"
      type = "N"
    },
    {
      name = "email"
      type = "S"
    }
  ]

  global_secondary_indexes = [
    {
      name            = "email-index"
      hash_key        = "email"
      projection_type = "ALL"
    }
  ]

  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  point_in_time_recovery_enabled = true
  server_side_encryption_enabled = true

  tags = {
    Environment = "production"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 4.0 |
