# Terraform Plan Role
data "aws_iam_policy_document" "terraform_plan_assume" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [var.github_oidc_provider_arn]
    }
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values = [
        "repo:${var.github_org}@${var.github_org_id}/${var.github_repo}@${var.github_repo_id}:pull_request"
      ]
    }
  }
}

resource "aws_iam_role" "terraform_plan" {
  name               = "${var.project_name}-terraform-plan-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.terraform_plan_assume.json
}

data "aws_iam_policy_document" "terraform_plan_permissions" {
  statement {
    sid = "ReadOnlyForPlan"
    actions = [
      "ec2:Describe*", "elasticloadbalancing:Describe*",
      "ecs:Describe*", "ecs:List*", "ecr:Describe*", "ecr:List*",
      "acm:Describe*", "acm:List*", "route53:Get*", "route53:List*",
      "logs:Describe*", "logs:Get*", "secretsmanager:Describe*",
      "secretsmanager:List*", "iam:Get*", "iam:List*", "iam:ListRolePolicies",
      "s3:GetBucket*", "s3:List*",
    ]
    resources = ["*"]
  }
  statement {
    sid       = "StateLockAndRead"
    actions   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
    resources = ["arn:aws:s3:::${var.state_bucket_name}/${var.project_name}/${var.environment}/*"]
  }
}

resource "aws_iam_role_policy" "terraform_plan_permissions" {
  name   = "${var.project_name}-terraform-plan-${var.environment}-permissions"
  role   = aws_iam_role.terraform_plan.id
  policy = data.aws_iam_policy_document.terraform_plan_permissions.json
}

# Terraform Apply Role
data "aws_iam_policy_document" "terraform_apply_assume" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [var.github_oidc_provider_arn]
    }
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values = [
        "repo:${var.github_org}@${var.github_org_id}/${var.github_repo}@${var.github_repo_id}:environment:${var.environment}"
      ]
    }
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:ref"
      values   = ["refs/heads/main"]
    }
  }
}

resource "aws_iam_role" "terraform_apply" {
  name               = "${var.project_name}-terraform-apply-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.terraform_apply_assume.json
}

data "aws_iam_policy_document" "terraform_apply_permissions" {
  statement {
    sid = "InfraServices"
    actions = [
      "ec2:*", "elasticloadbalancing:*", "ecs:*", "ecr:*",
      "acm:*", "route53:*", "logs:*", "secretsmanager:*",
      "s3:*", "application-autoscaling:*",
    ]
    resources = ["*"]
  }
  statement {
    sid     = "IamScopedToEnvironmentRoles"
    actions = ["iam:*"]
    resources = [
      "arn:aws:iam::*:role/${var.project_name}-${var.environment}-*",
      "arn:aws:iam::*:policy/${var.project_name}-${var.environment}-*",
    ]
  }
  statement {
    sid       = "OidcProviderReadOnly"
    actions   = ["iam:GetOpenIDConnectProvider"]
    resources = [var.github_oidc_provider_arn]
  }
  statement {
    sid    = "ProtectTerraformStateBucket"
    effect = "Deny"
    actions = [
      "s3:DeleteBucket", "s3:PutBucketPolicy", "s3:PutBucketVersioning",
      "s3:PutBucketPublicAccessBlock", "s3:PutEncryptionConfiguration", "s3:PutBucketAcl",
    ]
    resources = ["arn:aws:s3:::${var.state_bucket_name}"]
  }
}

resource "aws_iam_role_policy" "terraform_apply_permissions" {
  name   = "${var.project_name}-terraform-apply-${var.environment}-permissions"
  role   = aws_iam_role.terraform_apply.id
  policy = data.aws_iam_policy_document.terraform_apply_permissions.json
}
