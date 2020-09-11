resource "aws_iam_user" "admin" {
  name  = element(var.usernames, count.index)
  count = length(var.usernames)
}

resource "aws_iam_access_key" "admin_key" {
  user  = element(var.usernames, count.index)
  count = length(var.usernames)
  # without dependencies AWS provider creates resources in wrong order
  # i.e. first aws_iam_access_key even if aws_iam_user not created yet
  depends_on = [
    aws_iam_user.admin
  ]
}

resource "aws_iam_group_membership" "admins" {
    group = data.aws_iam_group.admins.group_name
    name = "admins"
    users = aws_iam_user.admin.*.name
}
