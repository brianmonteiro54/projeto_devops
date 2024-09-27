terraform {
  backend "s3" {
    bucket  = "brian-terraform"
    key     = "bia-dev/api-node/terraform.tfstate"
    region  = "us-east-1"
    profile = "brian"
  }
}