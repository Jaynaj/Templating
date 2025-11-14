output "bucket_id" {
  description = "Bucket ID"
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "Bucket ARN"
  value       = aws_s3_bucket.this.arn
}

output "bucket_domain_name" {
  description = "Bucket domain name"
  value       = aws_s3_bucket.this.bucket_domain_name
}

output "bucket_regional_domain_name" {
  description = "Regional domain name"
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}

output "website_endpoint" {
  description = "Website endpoint"
  value       = aws_s3_bucket_website_configuration.this.website_endpoint
}

output "website_domain" {
  description = "Website domain"
  value       = aws_s3_bucket_website_configuration.this.website_domain
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID"
  value       = try(aws_cloudfront_distribution.this[0].id, null)
}

output "cloudfront_distribution_arn" {
  description = "CloudFront distribution ARN"
  value       = try(aws_cloudfront_distribution.this[0].arn, null)
}

output "cloudfront_domain_name" {
  description = "CloudFront domain name"
  value       = try(aws_cloudfront_distribution.this[0].domain_name, null)
}

output "cloudfront_hosted_zone_id" {
  description = "CloudFront hosted zone ID for Route53 alias"
  value       = try(aws_cloudfront_distribution.this[0].hosted_zone_id, null)
}

output "cloudfront_oai_iam_arn" {
  description = "CloudFront Origin Access Identity IAM ARN"
  value       = try(aws_cloudfront_origin_access_identity.this[0].iam_arn, null)
}
