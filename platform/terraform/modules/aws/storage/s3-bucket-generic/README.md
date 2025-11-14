# S3 Bucket Generic Module

Comprehensive S3 bucket module with encryption, versioning, lifecycle policies, and security best practices.

## Features

- Server-side encryption (AES256 or KMS)
- Versioning support
- Public access blocking
- Lifecycle policies
- Access logging
- CORS configuration
- Bucket policies
- Cross-region replication

## Usage

```hcl
module "s3_bucket" {
  source = "../../modules/aws/storage/s3-bucket-generic"

  bucket_name        = "my-app-data"
  versioning_enabled = true
  sse_algorithm      = "aws:kms"
  kms_master_key_id  = aws_kms_key.s3.id

  # Lifecycle rules
  lifecycle_rules = [
    {
      id      = "transition-to-ia"
      enabled = true
      transitions = [
        {
          days          = 30
          storage_class = "STANDARD_IA"
        },
        {
          days          = 90
          storage_class = "GLACIER"
        }
      ]
      expiration = {
        days = 365
      }
    }
  ]

  # Enable access logging
  logging_target_bucket = module.log_bucket.bucket_id
  logging_target_prefix = "s3-access-logs/"

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
