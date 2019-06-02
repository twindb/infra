resource "aws_iam_user" "admin" {
    name = "${element(var.usernames, count.index)}"
    count = "${length(var.usernames)}"
}

resource "aws_iam_access_key" "admin_key" {
    user = "${element(var.usernames, count.index)}"
    count = "${length(var.usernames)}"
}

resource "aws_iam_user_policy_attachment" "admin_policy" {
    user = "${element(var.usernames, count.index)}"
    policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
    count = "${length(var.usernames)}"
}
