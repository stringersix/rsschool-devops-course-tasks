variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
}

variable "azs" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}