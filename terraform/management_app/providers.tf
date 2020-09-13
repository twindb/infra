provider "aws" {
  region  = "us-east-1"
  version = "~> 2.70"
}

provider "random" {
  version = "~> 2.3"
}

provider "template" {
  version = "~> 2.1"
}
