terraform {
    backend "s3" {
        region = "us-east-1"
        key = "github/terraform.tfstate"
        bucket = "twindb-terraform-states"
    }
}
