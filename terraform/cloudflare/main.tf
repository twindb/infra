provider "cloudflare" {
    email   = "${var.cloudflare_email}"
    token   = "${var.cloudflare_token}"
    version = "~> 1.10"
}

resource "cloudflare_zone" "twindb_com" {
    zone = "twindb.com"
}
