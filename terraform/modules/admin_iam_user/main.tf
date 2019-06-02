resource "aws_iam_user" "admin" {
    name = "${element(var.usernames, count.index)}"
    count = "${length(var.usernames)}"
}

resource "aws_iam_access_key" "admin_key" {
    user = "${element(var.usernames, count.index)}"
    count = "${length(var.usernames)}"
    # without dependencies AWS provider creates resources in wrong order
    # i.e. first aws_iam_access_key even if aws_iam_user not created yet
    depends_on = ["aws_iam_user.admin"]
}

resource "aws_iam_user_policy_attachment" "admin_policy" {
    user = "${element(var.usernames, count.index)}"
    policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
    count = "${length(var.usernames)}"
    depends_on = ["aws_iam_user.admin"]
}
