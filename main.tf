terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.18.0"
    }
  }

  backend "s3" {
    key     = "terraform.tfstate"
    encrypt = true
  }
}


provider "aws" {
  region = var.aws_region
}





