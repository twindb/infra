resource "aws_iam_user" "backup" {
    name = "backup"
}

resource "aws_iam_access_key" "backup" {
    user = "${aws_iam_user.backup.name}"
}

resource "aws_iam_user_policy" "s3_policy" {
    name = "s3_policy"
    user = "${aws_iam_user.backup.name}"

    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": "*"
        }
    ]
}
EOF
}
