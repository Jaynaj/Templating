resource "aws_s3_bucket" "this" {
  bucket        = var.bucket_name
  force_destroy = var.force_destroy

  tags = merge(
    var.tags,
    {
      Name    = var.bucket_name
      Purpose = "logs"
    }
  )
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = "Disabled"  # Logs typically don't need versioning
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = var.sse_algorithm
      kms_master_key_id = var.kms_master_key_id
    }
    bucket_key_enabled = var.bucket_key_enabled
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    id     = "transition-and-expire-logs"
    status = "Enabled"

    transition {
      days          = var.transition_to_ia_days
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = var.transition_to_glacier_days
      storage_class = "GLACIER"
    }

    transition {
      days          = var.transition_to_deep_archive_days
      storage_class = "DEEP_ARCHIVE"
    }

    expiration {
      days = var.expiration_days
    }

    noncurrent_version_expiration {
      noncurrent_days = 1
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }

  # Optional: Intelligent tiering for cost optimization
  dynamic "rule" {
    for_each = var.enable_intelligent_tiering ? [1] : []
    content {
      id     = "intelligent-tiering"
      status = "Enabled"

      transition {
        days          = 0
        storage_class = "INTELLIGENT_TIERING"
      }
    }
  }
}

# Bucket policy for log delivery (ALB, CloudFront, etc.)
resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = var.bucket_policy != null ? var.bucket_policy : data.aws_iam_policy_document.bucket_policy.json
}

data "aws_iam_policy_document" "bucket_policy" {
  # Allow ELB/ALB to write logs
  dynamic "statement" {
    for_each = var.allow_elb_logging ? [1] : []
    content {
      sid    = "AllowELBLogging"
      effect = "Allow"

      principals {
        type        = "AWS"
        identifiers = [data.aws_elb_service_account.main.arn]
      }

      actions = [
        "s3:PutObject"
      ]

      resources = [
        "${aws_s3_bucket.this.arn}/*"
      ]
    }
  }

  # Allow CloudFront to write logs
  dynamic "statement" {
    for_each = var.allow_cloudfront_logging ? [1] : []
    content {
      sid    = "AllowCloudFrontLogging"
      effect = "Allow"

      principals {
        type        = "AWS"
        identifiers = [data.aws_cloudfront_log_delivery_canonical_user_id.main.id]
      }

      actions = [
        "s3:PutObject"
      ]

      resources = [
        "${aws_s3_bucket.this.arn}/*"
      ]
    }
  }

  # Deny insecure transport
  statement {
    sid    = "DenyInsecureTransport"
    effect = "Deny"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:*"
    ]

    resources = [
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*"
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

data "aws_elb_service_account" "main" {}

data "aws_cloudfront_log_delivery_canonical_user_id" "main" {}

# Object lock for compliance (optional)
resource "aws_s3_bucket_object_lock_configuration" "this" {
  count = var.enable_object_lock ? 1 : 0

  bucket = aws_s3_bucket.this.id

  rule {
    default_retention {
      mode = var.object_lock_mode
      days = var.object_lock_days
    }
  }
}
