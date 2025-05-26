terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.98.0"
    }
  }
  required_version = ">= 1.12.0"
}

provider "aws" {
  region = "us-east-1"
}
