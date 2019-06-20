module "backup" {
    source = "../modules/twindb-gitflow-repo/"
    name = "backup"
    description = "TwinDB Backup"
    private = false

    has_travis = true

    has_documentation = true
    rtd_url = "https://readthedocs.org/api/v2/webhook/twindb-backup/58216/"
}

module "chef-repo" {
    source = "../modules/twindb-github-repo/"
    name = "chef-repo"
    description = "Chef recipes"
    has_travis = true
}

module "cookbook-twindb-repo" {
    source = "../modules/twindb-gitflow-repo/"
    name = "cookbook-twindb-repo"
    description = "A Chef cookbook to setup and configure TwinDB repository"
}

module "dd-agent" {
    source = "../modules/twindb-github-repo/"
    name = "dd-agent"
    description = "Datadog Agent"
    private = false
}

module "dd-agent-packaging" {
    source = "../modules/twindb-github-repo/"
    name = "dd-agent-packaging"
    description = "Packaging of dd-agent"
}

module "docker-percona-xtradb-cluster" {
    source = "../modules/twindb-github-repo/"
    name = "docker-percona-xtradb-cluster"
    description = "A Docker image to run Percona XtraDB Cluster node inside a Docker container"
}

module "docker-proxysql" {
    source = "../modules/twindb-github-repo/"
    name = "docker-proxysql"
    description = "Docker ProxySQL image"
}

module "extjs" {
    source = "../modules/twindb-github-repo/"
    name = "extjs"
    description = "ExtJS version 6.2"
}

module "infra" {
    source = "../modules/twindb-github-repo/"
    name = "infra"
    description = "TwinDB infrastructure"
    has_travis = true
    private = false
}

module "monitoring" {
    source = "../modules/twindb-github-repo/"
    name = "monitoring"
    description = "Monitoring, dashboards and alerting"
}

module "mydumper" {
    source = "../modules/twindb-github-repo/"
    name = "mydumper"
    description = "TwinDB fork of official mydumper project"
    private = false
}

module "omnibus-centos" {
    source = "../modules/twindb-github-repo/"
    name = "omnibus-centos"
    description = "A docker image containing centos, ruby, go, git, omnibus-ruby, omnibus-software."
    private = false
    default_branch = "7"
    has_branch_protection = false

    has_docker_hub = true
    docker_hub_url = "https://cloud.docker.com/api/build/v1/vcs/dacbed82-19ae-47ba-a5e3-be729aa0aa32/trigger/call/"
}

module "omnibus-debian" {
    source = "../modules/twindb-github-repo/"
    name = "omnibus-debian"
    description = "Docker images containing debian, ruby, go, git, omnibus-ruby, omnibus-software"
    private = false
    default_branch = "jessie"
    has_branch_protection = false

    has_docker_hub = true
    docker_hub_url = "https://cloud.docker.com/api/build/v1/vcs/5496a7e8-d5a2-48e9-86be-2be900c06d4f/trigger/call/"
}

module "omnibus-software" {
    source = "../modules/twindb-github-repo/"
    name = "omnibus-software"
    description = "Open Source Software for use in Omnibus built packages"
    private = false
}

module "omnibus-ubuntu" {
    source = "../modules/twindb-github-repo/"
    name = "omnibus-ubuntu"
    description = "Docker images containing ubuntu, ruby, git, omnibus-ruby, omnibus-software for building twindb-backup"
    private = false
    default_branch = "trusty"
    has_branch_protection = false

    has_docker_hub = true
    docker_hub_url = "https://cloud.docker.com/api/build/v1/vcs/2bd3e633-056e-4007-a32e-75f584db81eb/trigger/call/"
}

module "proxysql-tools" {
    source = "../modules/twindb-gitflow-repo/"
    name = "proxysql-tools"
    description = "ProxySQL Tools manage proxysql backends."
    private = false
    has_travis = true
}

module "pyetcd" {
    source = "../modules/twindb-gitflow-repo/"
    name = "pyetcd"
    description = "Etcd SDK"
    private = false
    has_travis = true
}

module "recovery" {
    source = "../modules/twindb-gitflow-repo/"
    name = "recovery"
    description = "TwinDB Data Recovery Portal"
}

module "terraform-twindb-github-repo" {
    source = "../modules/twindb-github-repo/"
    name = "terraform-twindb-github-repo"
    description = "GitHub workflow terraform module"
    has_issues = true
    private = false
}

module "twindb" {
    source = "../modules/twindb-gitflow-repo/"
    name = "twindb"
    description = "TwinDB backup for MySQL"
}

module "twindb-backup-service" {
    source = "../modules/twindb-gitflow-repo/"
    name = "twindb-backup-service"
    description = "TwinDB Backup Service"
}

module "twindb-benchmarks" {
    source = "../modules/twindb-github-repo/"
    name = "twindb-benchmarks"
}

module "twindb-release" {
    source = "../modules/twindb-github-repo/"
    name = "twindb-release"
}

module "twindb-terraform-modules" {
    source = "../modules/twindb-github-repo/"
    name = "twindb-terraform-modules"
    description = "Terraform modules for Infrastructure as Code"
    has_issues = true
    private = false
}

module "twindb-table-compare" {
    source = "../modules/twindb-gitflow-repo/"
    name = "twindb-table-compare"
    description = "TwinDB Table Compare shows differences between master and slave"
    private = false
    has_documentation = true
    rtd_url = "https://readthedocs.org/api/v2/webhook/twindb-table-compare/58215/"
    has_travis = true
}

module "twindb-xtrabackup-80" {
    source = "../modules/twindb-github-repo/"
    name = "twindb-xtrabackup-80"
    description = "TwinDB Package of Percona Xtrabackup 8.0"
    has_issues = true
    private = false
}

module "twindb_cloudflare" {
    source = "../modules/twindb-gitflow-repo/"
    name = "twindb_cloudflare"
    private = false
    has_travis = true
}

module "twindb_infrastructure" {
    source = "../modules/twindb-gitflow-repo/"
    name = "twindb_infrastructure"
    private = false
    has_travis = true
}

module "undrop-for-innodb" {
    source = "../modules/twindb-gitflow-repo/"
    name = "undrop-for-innodb"
    description = "TwinDB data recovery toolkit for MySQL/InnoDB"
    private = false
}

module "website" {
    source = "../modules/twindb-gitflow-repo/"
    name = "website"
    description = "TwinDB main website"
    allow_rebase_merge = false
    allow_squash_merge = false
}
