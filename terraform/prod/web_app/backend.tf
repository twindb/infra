terraform {
  backend "s3" {
    region = "us-east-1"
    key = "production/web_app/terraform.tfstate"
    bucket = "twindb-terraform-states"
  }
}