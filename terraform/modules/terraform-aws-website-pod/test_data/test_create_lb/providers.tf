provider "aws" {
  version = "~> 2.41"
  region  = var.region
}

provider "template" {
  version = "~> 2.1"
}
