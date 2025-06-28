variable "permissions" {
  type        = list(string)
  description = "Github actions role permissions"
  default = [
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
    "arn:aws:iam::aws:policy/AmazonRoute53FullAccess",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/IAMFullAccess",
    "arn:aws:iam::aws:policy/AmazonVPCFullAccess",
    "arn:aws:iam::aws:policy/AmazonSQSFullAccess",
    "arn:aws:iam::aws:policy/AmazonEventBridgeFullAccess"
  ]
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "github_actions_role" {
  type        = string
  description = "Github actions role name"
}

variable "github_org" {
  type        = string
  description = "GitHub organization name / GitHub account username"
}

variable "github_repo" {
  type        = string
  description = "Name of repository"
}

variable "bucket_name" {
  type        = string
  description = "Name of S3 bucket"
}
