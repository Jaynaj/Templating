variable "bucket_name" {
  description = "Name of the S3 bucket for static website"
  type        = string
}

variable "force_destroy" {
  description = "Allow bucket to be destroyed even if it contains objects"
  type        = bool
  default     = false
}

variable "index_document" {
  description = "Index document for the website"
  type        = string
  default     = "index.html"
}

variable "error_document" {
  description = "Error document for the website"
  type        = string
  default     = "error.html"
}

variable "routing_rules" {
  description = "List of routing rules for the website"
  type = list(object({
    condition = map(string)
    redirect  = map(string)
  }))
  default = []
}

variable "versioning_enabled" {
  description = "Enable versioning"
  type        = bool
  default     = false
}

variable "sse_algorithm" {
  description = "Server-side encryption algorithm (AES256 or aws:kms)"
  type        = string
  default     = "AES256"
}

variable "kms_master_key_id" {
  description = "KMS key ID for encryption"
  type        = string
  default     = null
}

variable "bucket_key_enabled" {
  description = "Enable S3 Bucket Keys for SSE-KMS"
  type        = bool
  default     = true
}

variable "block_public_access" {
  description = "Block all public access (set to false for public websites without CloudFront)"
  type        = bool
  default     = true
}

variable "enable_public_access" {
  description = "Enable public read access via bucket policy"
  type        = bool
  default     = false
}

variable "custom_bucket_policy" {
  description = "Custom bucket policy JSON (overrides default)"
  type        = string
  default     = null
}

variable "use_cloudfront" {
  description = "Use CloudFront for content delivery (recommended)"
  type        = bool
  default     = true
}

variable "create_cloudfront_distribution" {
  description = "Create a CloudFront distribution for the bucket"
  type        = bool
  default     = false
}

variable "cloudfront_ipv6_enabled" {
  description = "Enable IPv6 for CloudFront"
  type        = bool
  default     = true
}

variable "cloudfront_comment" {
  description = "Comment for the CloudFront distribution"
  type        = string
  default     = null
}

variable "cloudfront_aliases" {
  description = "CNAMEs (alternate domain names) for CloudFront"
  type        = list(string)
  default     = []
}

variable "cloudfront_price_class" {
  description = "CloudFront price class (PriceClass_All, PriceClass_200, PriceClass_100)"
  type        = string
  default     = "PriceClass_100"
}

variable "cloudfront_web_acl_id" {
  description = "AWS WAF web ACL ID for CloudFront"
  type        = string
  default     = null
}

variable "cloudfront_forward_query_string" {
  description = "Forward query strings to origin"
  type        = bool
  default     = false
}

variable "cloudfront_forward_headers" {
  description = "Headers to forward to origin"
  type        = list(string)
  default     = []
}

variable "cloudfront_viewer_protocol_policy" {
  description = "Viewer protocol policy (allow-all, https-only, redirect-to-https)"
  type        = string
  default     = "redirect-to-https"
}

variable "cloudfront_min_ttl" {
  description = "Minimum TTL in seconds"
  type        = number
  default     = 0
}

variable "cloudfront_default_ttl" {
  description = "Default TTL in seconds"
  type        = number
  default     = 3600
}

variable "cloudfront_max_ttl" {
  description = "Maximum TTL in seconds"
  type        = number
  default     = 86400
}

variable "cloudfront_compress" {
  description = "Enable CloudFront compression"
  type        = bool
  default     = true
}

variable "cloudfront_custom_error_responses" {
  description = "Custom error responses for CloudFront"
  type = list(object({
    error_code            = number
    response_code         = optional(number)
    response_page_path    = optional(string)
    error_caching_min_ttl = optional(number)
  }))
  default = []
}

variable "cloudfront_geo_restriction_type" {
  description = "Geo restriction type (none, whitelist, blacklist)"
  type        = string
  default     = "none"
}

variable "cloudfront_geo_restriction_locations" {
  description = "Country codes for geo restriction"
  type        = list(string)
  default     = []
}

variable "cloudfront_acm_certificate_arn" {
  description = "ACM certificate ARN for custom domain"
  type        = string
  default     = null
}

variable "cloudfront_minimum_protocol_version" {
  description = "Minimum SSL/TLS protocol version"
  type        = string
  default     = "TLSv1.2_2021"
}

variable "cors_rules" {
  description = "CORS rules for the bucket"
  type = list(object({
    allowed_headers = optional(list(string))
    allowed_methods = list(string)
    allowed_origins = list(string)
    expose_headers  = optional(list(string))
    max_age_seconds = optional(number)
  }))
  default = []
}

variable "enable_lifecycle_rules" {
  description = "Enable lifecycle rules for old versions"
  type        = bool
  default     = false
}

variable "noncurrent_version_expiration_days" {
  description = "Days until noncurrent versions expire"
  type        = number
  default     = 90
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
