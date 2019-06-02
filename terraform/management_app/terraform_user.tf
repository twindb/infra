# User to run terraform apply
resource "aws_iam_user" "terraform_ci_user" {
    name = "terraform"
}

resource "aws_iam_access_key" "terraform_ci_user" {
    user = "${aws_iam_user.terraform_ci_user.name}"
}

resource "aws_iam_user_policy_attachment" "terraform_policy" {
    user       = "${aws_iam_user.terraform_ci_user.name}"
    policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
