module "admins" {
    source = "../modules/admin_iam_user"
    usernames = "${var.admins}"
}
