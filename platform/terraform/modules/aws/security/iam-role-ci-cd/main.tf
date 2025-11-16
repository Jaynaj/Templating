data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = var.trusted_services
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "this" {
  name                  = var.name
  description           = var.description
  assume_role_policy    = data.aws_iam_policy_document.assume_role.json
  max_session_duration  = var.max_session_duration
  force_detach_policies = true

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}

resource "aws_iam_role_policy_attachment" "managed" {
  for_each = toset(var.managed_policy_arns)

  role       = aws_iam_role.this.name
  policy_arn = each.value
}

resource "aws_iam_role_policy" "inline" {
  for_each = var.inline_policies

  name   = each.key
  role   = aws_iam_role.this.id
  policy = each.value
}

# ECR access policy
resource "aws_iam_role_policy" "ecr" {
  count = length(var.ecr_repositories) > 0 ? 1 : 0

  name = "${var.name}-ecr-access"
  role = aws_iam_role.this.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload"
        ]
        Resource = var.ecr_repositories
      }
    ]
  })
}

# S3 access policy
resource "aws_iam_role_policy" "s3" {
  count = length(var.s3_buckets) > 0 ? 1 : 0

  name = "${var.name}-s3-access"
  role = aws_iam_role.this.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = concat(var.s3_buckets, [for bucket in var.s3_buckets : "${bucket}/*"])
      }
    ]
  })
}
