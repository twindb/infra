provider "cloudflare" {
    email   = var.cloudflare_email
    token   = var.cloudflare_token
    version = "~> 1.10"
}
