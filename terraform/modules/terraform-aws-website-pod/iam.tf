resource "aws_iam_role" "revdb_webserver_role" {
  name = "revdb_webserver_role"

  assume_role_policy = jsonencode(
    {
      Version : "2012-10-17",
      Statement : [
        {
          Action : "sts:AssumeRole",
          Principal : {
            Service : "ec2.amazonaws.com"
          },
          Effect : "Allow",
          Sid : ""
        }
      ]
    }
  )

  tags = merge(
    var.tags,
    local.common_tags,
    {
      "Name"        = "revdb_webserver"
      "environment" = var.environment
      "service"     = var.service_name
    }
  )
}

resource "aws_iam_role_policy_attachment" "revdb_webserver_policy_attachment" {
  role       = aws_iam_role.revdb_webserver_role.name
  policy_arn = aws_iam_policy.revdb_webserver_policy.arn
}

resource "aws_iam_instance_profile" "revdb_webserver_profile" {
  name = "revdb_webserver_profile"
  role = aws_iam_role.revdb_webserver_role.name
}

resource "aws_iam_policy" "revdb_webserver_policy" {
  name        = "revdb_webserver_policy"
  path        = "/"
  description = "revdb_webserver IAM Policy"
  policy      = local.iam_policy
}
