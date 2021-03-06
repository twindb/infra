module "backup" {
    source = "../modules/twindb-github-repo/"
    name = "backup"
    description = "TwinDB Backup"
    homepage_url = "https://twindb-backup.readthedocs.io/en/stable/"
    private = false

    has_travis = 0

    has_documentation = 0
    rtd_url = "https://readthedocs.org/api/v2/webhook/twindb-backup/58216/"
}
//
//module "dd-agent" {
//    source = "../modules/twindb-github-repo/"
//    name = "dd-agent"
//    description = "Datadog Agent"
//    private = false
//}
//
//module "infra" {
//    source = "../modules/twindb-github-repo/"
//    name = "infra"
//    description = "TwinDB infrastructure"
//    has_travis = 1
//    private = false
//}
//
//module "mydumper" {
//    source = "../modules/twindb-github-repo/"
//    name = "mydumper"
//    description = "TwinDB fork of official mydumper project"
//    private = false
//}
//
//module "omnibus-centos" {
//    source = "../modules/twindb-github-repo/"
//    name = "omnibus-centos"
//    description = "A docker image containing centos, ruby, go, git, omnibus-ruby, omnibus-software."
//    private = false
//    default_branch = "7"
//    has_branch_protection = 0
//
//    has_docker_hub = 1
//    docker_hub_url = "https://cloud.docker.com/api/build/v1/vcs/dacbed82-19ae-47ba-a5e3-be729aa0aa32/trigger/call/"
//}
//
//module "omnibus-debian" {
//    source = "../modules/twindb-github-repo/"
//    name = "omnibus-debian"
//    description = "Docker images containing debian, ruby, go, git, omnibus-ruby, omnibus-software"
//    private = false
//    default_branch = "jessie"
//    has_branch_protection = 0
//
//    has_docker_hub = 1
//    docker_hub_url = "https://cloud.docker.com/api/build/v1/vcs/5496a7e8-d5a2-48e9-86be-2be900c06d4f/trigger/call/"
//}
//
//module "omnibus-software" {
//    source = "../modules/twindb-github-repo/"
//    name = "omnibus-software"
//    description = "Open Source Software for use in Omnibus built packages"
//    private = false
//}
//
//module "omnibus-ubuntu" {
//    source = "../modules/twindb-github-repo/"
//    name = "omnibus-ubuntu"
//    description = "Docker images containing ubuntu, ruby, git, omnibus-ruby, omnibus-software for building twindb-backup"
//    private = false
//    default_branch = "trusty"
//    has_branch_protection = 0
//
//    has_docker_hub = 1
//    docker_hub_url = "https://cloud.docker.com/api/build/v1/vcs/2bd3e633-056e-4007-a32e-75f584db81eb/trigger/call/"
//}
//
//module "proxysql-tools" {
//    source = "../modules/twindb-gitflow-repo/"
//    name = "proxysql-tools"
//    description = "ProxySQL Tools manage proxysql backends."
//    private = false
//    has_travis = 1
//}
//
//module "pyetcd" {
//    source = "../modules/twindb-gitflow-repo/"
//    name = "pyetcd"
//    description = "Etcd SDK"
//    private = false
//    has_travis = 1
//}
//
//module "terraform-ci" {
//    source = "../modules/twindb-github-repo_2/"
//    name = "terraform-ci"
//    description = "Helper tool to merry Terraform and Travis-CI"
//    private = false
//}
//
//module "terraform-twindb-github-repo" {
//    source = "../modules/twindb-github-repo/"
//    name = "terraform-twindb-github-repo"
//    description = "GitHub workflow terraform module"
//    has_issues = true
//    private = false
//}
//
//module "twindb-terraform-modules" {
//    source = "../modules/twindb-github-repo/"
//    name = "twindb-terraform-modules"
//    description = "Terraform modules for Infrastructure as Code"
//    has_issues = true
//    private = false
//}
//
//module "twindb-table-compare" {
//    source = "../modules/twindb-gitflow-repo/"
//    name = "twindb-table-compare"
//    description = "TwinDB Table Compare shows differences between master and slave"
//    private = false
//    has_documentation = 1
//    rtd_url = "https://readthedocs.org/api/v2/webhook/twindb-table-compare/58215/"
//    has_travis = 1
//}
//
//module "twindb-xtrabackup-80" {
//    source = "../modules/twindb-github-repo/"
//    name = "twindb-xtrabackup-80"
//    description = "TwinDB Package of Percona Xtrabackup 8.0"
//    has_issues = true
//    private = false
//}
//
//module "twindb_cloudflare" {
//    source = "../modules/twindb-gitflow-repo/"
//    name = "twindb_cloudflare"
//    private = false
//    has_travis = 1
//}
//
//module "twindb_infrastructure" {
//    source = "../modules/twindb-gitflow-repo/"
//    name = "twindb_infrastructure"
//    private = false
//    has_travis = 1
//}
//
module "undrop-for-innodb" {
    source = "../modules/twindb-gitflow-repo/"
    name = "undrop-for-innodb"
    description = "TwinDB data recovery toolkit for MySQL/InnoDB"
    private = false
}
