# Create S3 bucket
resource "aws_s3_bucket" "bucket" {
  bucket        = var.bucket_name
  force_destroy = true
}


data "external" "oidc_thumbprint" {
  program = ["bash", "${path.module}/get_thumbprint.sh"]
}

# Create OIDC-provider for GitHub
resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.external.oidc_thumbprint.result.thumbprint]
}

# IAM Role for GitHub Actions
resource "aws_iam_role" "github_actions_role" {
  name = var.github_actions_role

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = aws_iam_openid_connect_provider.github.arn
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringLike = {
          "token.actions.githubusercontent.com:sub" = "repo:${var.github_org}/${var.github_repo}:*"
        },
      }
    }]
  })
}

# IAM Role policy attachment
resource "aws_iam_role_policy_attachment" "github_actions_policies" {
  for_each = toset(var.permissions)

  role       = aws_iam_role.github_actions_role.name
  policy_arn = each.key
}
