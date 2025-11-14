resource "aws_s3_bucket" "this" {
  bucket        = var.bucket_name
  force_destroy = var.force_destroy

  tags = merge(
    var.tags,
    {
      Name    = var.bucket_name
      Purpose = "static-website"
    }
  )
}

resource "aws_s3_bucket_website_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  index_document {
    suffix = var.index_document
  }

  dynamic "error_document" {
    for_each = var.error_document != null ? [var.error_document] : []
    content {
      key = error_document.value
    }
  }

  dynamic "routing_rule" {
    for_each = var.routing_rules
    content {
      condition {
        key_prefix_equals = lookup(routing_rule.value.condition, "key_prefix_equals", null)
        http_error_code_returned_equals = lookup(routing_rule.value.condition, "http_error_code_returned_equals", null)
      }

      redirect {
        host_name               = lookup(routing_rule.value.redirect, "host_name", null)
        http_redirect_code      = lookup(routing_rule.value.redirect, "http_redirect_code", null)
        protocol                = lookup(routing_rule.value.redirect, "protocol", null)
        replace_key_prefix_with = lookup(routing_rule.value.redirect, "replace_key_prefix_with", null)
        replace_key_with        = lookup(routing_rule.value.redirect, "replace_key_with", null)
      }
    }
  }
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = var.versioning_enabled ? "Enabled" : "Disabled"
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

# Public access configuration for static websites
resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  # Allow public access for static website hosting
  block_public_acls       = var.block_public_access
  block_public_policy     = var.block_public_access
  ignore_public_acls      = var.block_public_access
  restrict_public_buckets = var.block_public_access
}

# Bucket policy for public read access (when not using CloudFront)
resource "aws_s3_bucket_policy" "this" {
  count = var.enable_public_access && !var.use_cloudfront ? 1 : 0

  bucket = aws_s3_bucket.this.id
  policy = var.custom_bucket_policy != null ? var.custom_bucket_policy : data.aws_iam_policy_document.public_read[0].json

  depends_on = [aws_s3_bucket_public_access_block.this]
}

data "aws_iam_policy_document" "public_read" {
  count = var.enable_public_access && !var.use_cloudfront && var.custom_bucket_policy == null ? 1 : 0

  statement {
    sid    = "PublicReadGetObject"
    effect = "Allow"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.this.arn}/*"
    ]
  }
}

# CloudFront Origin Access Identity (OAI)
resource "aws_cloudfront_origin_access_identity" "this" {
  count = var.use_cloudfront ? 1 : 0

  comment = "OAI for ${var.bucket_name}"
}

# Bucket policy for CloudFront access
resource "aws_s3_bucket_policy" "cloudfront" {
  count = var.use_cloudfront ? 1 : 0

  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.cloudfront[0].json

  depends_on = [aws_s3_bucket_public_access_block.this]
}

data "aws_iam_policy_document" "cloudfront" {
  count = var.use_cloudfront ? 1 : 0

  statement {
    sid    = "CloudFrontReadGetObject"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.this[0].iam_arn]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.this.arn}/*"
    ]
  }
}

# CloudFront Distribution (optional)
resource "aws_cloudfront_distribution" "this" {
  count = var.create_cloudfront_distribution ? 1 : 0

  enabled             = true
  is_ipv6_enabled     = var.cloudfront_ipv6_enabled
  default_root_object = var.index_document
  comment             = var.cloudfront_comment
  aliases             = var.cloudfront_aliases
  price_class         = var.cloudfront_price_class
  web_acl_id          = var.cloudfront_web_acl_id

  origin {
    domain_name = aws_s3_bucket.this.bucket_regional_domain_name
    origin_id   = "S3-${var.bucket_name}"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.this[0].cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${var.bucket_name}"

    forwarded_values {
      query_string = var.cloudfront_forward_query_string
      headers      = var.cloudfront_forward_headers

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = var.cloudfront_viewer_protocol_policy
    min_ttl                = var.cloudfront_min_ttl
    default_ttl            = var.cloudfront_default_ttl
    max_ttl                = var.cloudfront_max_ttl
    compress               = var.cloudfront_compress
  }

  dynamic "custom_error_response" {
    for_each = var.cloudfront_custom_error_responses
    content {
      error_code            = custom_error_response.value.error_code
      response_code         = lookup(custom_error_response.value, "response_code", null)
      response_page_path    = lookup(custom_error_response.value, "response_page_path", null)
      error_caching_min_ttl = lookup(custom_error_response.value, "error_caching_min_ttl", 300)
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = var.cloudfront_geo_restriction_type
      locations        = var.cloudfront_geo_restriction_locations
    }
  }

  viewer_certificate {
    acm_certificate_arn            = var.cloudfront_acm_certificate_arn
    ssl_support_method             = var.cloudfront_acm_certificate_arn != null ? "sni-only" : null
    minimum_protocol_version       = var.cloudfront_acm_certificate_arn != null ? var.cloudfront_minimum_protocol_version : null
    cloudfront_default_certificate = var.cloudfront_acm_certificate_arn == null ? true : false
  }

  tags = var.tags
}

# CORS configuration
resource "aws_s3_bucket_cors_configuration" "this" {
  count = length(var.cors_rules) > 0 ? 1 : 0

  bucket = aws_s3_bucket.this.id

  dynamic "cors_rule" {
    for_each = var.cors_rules
    content {
      allowed_headers = lookup(cors_rule.value, "allowed_headers", null)
      allowed_methods = cors_rule.value.allowed_methods
      allowed_origins = cors_rule.value.allowed_origins
      expose_headers  = lookup(cors_rule.value, "expose_headers", null)
      max_age_seconds = lookup(cors_rule.value, "max_age_seconds", null)
    }
  }
}

# Lifecycle configuration
resource "aws_s3_bucket_lifecycle_configuration" "this" {
  count = var.enable_lifecycle_rules ? 1 : 0

  bucket = aws_s3_bucket.this.id

  rule {
    id     = "transition-old-versions"
    status = "Enabled"

    noncurrent_version_transition {
      noncurrent_days = 30
      storage_class   = "STANDARD_IA"
    }

    noncurrent_version_transition {
      noncurrent_days = 90
      storage_class   = "GLACIER"
    }

    noncurrent_version_expiration {
      noncurrent_days = var.noncurrent_version_expiration_days
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}
