locals {
  common_tags = {
    environment = var.environment
    managed-by  = "terraform"
    account     = data.aws_caller_identity.current.account_id
    service     = var.service_name
  }
  iam_statements = concat(
    [
      {

        Sid : "VisualEditor0",
        Effect : "Allow",
        Action : [
          "secretsmanager:GetRandomPassword",
          "ec2:Describe*",
          "s3:ListBucket"
        ],
        Resource : "*"
      }
    ],
    length(var.secrets_arn_list) > 0
    ? [{
      Sid : "VisualEditor1",
      Effect : "Allow",
      Action : [
        "secretsmanager:GetResourcePolicy",
        "secretsmanager:GetSecretValue",
        "secretsmanager:DescribeSecret",
        "secretsmanager:ListSecretVersionIds"
      ],
      Resource : var.secrets_arn_list
    }] : [],
    length(var.keys_arn_list) > 0 ?
    [
      {
        Sid : "VisualEditor2",
        Effect : "Allow",
        Action : "kms:*",
        Resource : var.keys_arn_list
      }
    ] : [],
    length(var.s3_bucket_rw_list) > 0 ?
    [
      {
        Sid : "VisualEditor3",
        Effect : "Allow",
        Action : [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject"
        ],
        Resource : var.s3_bucket_rw_list
      },
    ] : [],
    length(var.s3_bucket_ro_list) > 0 ?
    [
      {
        Sid : "VisualEditor4",
        Effect : "Allow",
        Action : [
          "s3:GetObject",
        ],
        Resource : var.s3_bucket_ro_list
      }
    ] : []
  )
  iam_policy = jsonencode(
    {
      Version : "2012-10-17",
      Statement : local.iam_statements
    }
  )
}
