variable "user" {
    description = "IAM user name"
}

variable "force_destroy" {
    description = "If true, terraform will destroy user even if they have MFA"
    default = false
}
