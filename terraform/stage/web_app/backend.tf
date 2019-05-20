terraform {
  backend "s3" {
    region = "us-east-1"
    key = "staging/web_app/terraform.tfstate"
    bucket = "twindb-terraform-states"
  }
}