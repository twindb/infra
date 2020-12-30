provider "cloudflare" {
    email   = var.cloudflare_email
    token   = var.cloudflare_token
    version = "~> 1.10"
}

provider "aws" {
    region = "us-east-1"
    version = "~> 2.11"
}
