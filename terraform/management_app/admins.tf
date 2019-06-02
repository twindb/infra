resource "aws_iam_user" "admins" {
    name = "${element(var.admins, count.index)}"
    count = "${length(var.admins)}"
}

resource "aws_iam_access_key" "admin_keys" {
    user = "${element(var.admins, count.index)}"
    count = "${length(var.admins)}"
}

resource "aws_iam_user_policy_attachment" "admin_policy" {
    user = "${element(var.admins, count.index)}"
    policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
    count = "${length(var.admins)}"
}
