terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.18.0"
    }
  }
}

resource "aws_s3_bucket" "bucket" {
# bucket  = here-must-be-your-backet-name
  force_destroy = true
}