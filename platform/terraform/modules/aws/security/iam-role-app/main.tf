data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com", "ecs-tasks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }

  dynamic "statement" {
    for_each = length(var.service_accounts) > 0 ? [1] : []
    content {
      effect = "Allow"

      principals {
        type        = "AWS"
        identifiers = var.service_accounts
      }

      actions = ["sts:AssumeRole"]
    }
  }

  dynamic "statement" {
    for_each = length(var.oidc_provider_arns) > 0 ? [1] : []
    content {
      effect = "Allow"

      principals {
        type        = "Federated"
        identifiers = var.oidc_provider_arns
      }

      actions = ["sts:AssumeRoleWithWebIdentity"]
    }
  }
}

resource "aws_iam_role" "this" {
  name                  = var.name
  description           = var.description
  assume_role_policy    = data.aws_iam_policy_document.assume_role.json
  max_session_duration  = var.max_session_duration
  permissions_boundary  = var.permissions_boundary
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
