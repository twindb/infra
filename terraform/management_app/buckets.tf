resource "aws_s3_bucket" "twindb-terraform-states" {
    acl = "private"
    force_destroy = false

    versioning {
        enabled = true
    }

    lifecycle {
        prevent_destroy = true
    }

    tags {
        Name = "Terraform State File Storage"
    }
}

resource "aws_s3_bucket" "twindb-release" {
    bucket = "twindb-release"
    region = "${var.aws_region}"
    acl = "public-read"
    force_destroy = false
}

resource "aws_s3_bucket" "omnibus-cache-twindb-backup" {
    acl = "public-read"
    force_destroy = true
}
