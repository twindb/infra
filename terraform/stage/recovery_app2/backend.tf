terraform {
  backend "s3" {
    region = "us-east-1"
    key = "staging/recovery_app2/terraform.tfstate"
    bucket = "twindb-terraform-states"
  }
}