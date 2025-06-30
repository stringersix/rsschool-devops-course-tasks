variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
}

variable "azs" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}

variable "bastion_key" {
  type = string
}

variable "bastion_key_path" {
  type = string
}

variable "allowed_ip" {
  type = string
}