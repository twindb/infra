module "admin_0" {
    source = "../modules/admin_iam_user"
    user = "${element(var.admins, 0)}"
}

module "admin_1" {
    source = "../modules/admin_iam_user"
    user = "${element(var.admins, 1)}"
    force_destroy = true
}
