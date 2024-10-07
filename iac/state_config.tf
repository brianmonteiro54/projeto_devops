terraform {
  backend "s3" {
    bucket  = "brian-terraform"
    key     = "api-node/terraform.tfstate"
    region  = "us-east-1"
    profile = "brian"
  }
}