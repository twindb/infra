variable "name" {}

variable "description" {
    default = "TwinDB Project"
}

variable "default_branch" {
    default = "develop"
}

variable "release_branch" {
    default = "master"
}

variable "private" {
    default = true
}

variable "has_branch_protection" {
    default = 1
}

variable "has_issues" {
    default = true
}

variable "has_downloads" {
    default = false
}

variable "has_documentation" {
    default = 0
}

variable "has_docker_hub" {
    default = 0
}

variable "has_travis" {
    default = 0
}

variable "has_slack" {
    default = false
}

variable "homepage_url" {
    default = "https://twindb.com"
}

variable "allow_rebase_merge" {
    default = true
}

variable "allow_squash_merge" {
    default = true
}

variable "rtd_url" {
    default = "https://readthedocs.org/"
}

variable "slack_url" {
    default = "https://hooks.slack.com/services/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"
}

variable "docker_hub_url" {
    default = ""
}
