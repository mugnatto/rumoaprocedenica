resource "aws_iam_role" "github_actions" {
  name = "gha-deploy-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement: [
      {
        Effect: "Allow",
        Principal: {
          Federated: "arn:aws:iam::${var.AWS_ACCOUNT_ID}:oidc-provider/token.actions.githubusercontent.com"
        },
        Action: "sts:AssumeRoleWithWebIdentity",
        Condition: {
          StringLike: {
            "token.actions.githubusercontent.com:sub": "repo:mugnatto/rumoaprocedenica:*"
          }
        }
      }
    ]
  })
}

# Política para CloudFront
resource "aws_iam_role_policy_attachment" "cloudfront_full" {
  role       = aws_iam_role.github_actions.name
  policy_arn = "arn:aws:iam::aws:policy/CloudFrontFullAccess"
}

# Política para gerenciar IAM (necessário para Terraform)
resource "aws_iam_role_policy_attachment" "iam_full" {
  role       = aws_iam_role.github_actions.name
  policy_arn = "arn:aws:iam::aws:policy/IAMFullAccess"
}

# Política customizada para permissões específicas
resource "aws_iam_role_policy" "terraform_policy" {
  name = "terraform-policy"
  role = aws_iam_role.github_actions.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:*",
          "cloudfront:*",
          "iam:*",
          "dynamodb:*",
          "route53:*"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:DeleteObject"
        ]
        Resource = [
          "arn:aws:s3:::${var.bucket_name}",
          "arn:aws:s3:::${var.bucket_name}/*"
        ]
      }
    ]
  })
}
