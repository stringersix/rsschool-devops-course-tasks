variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
}

variable "bucket_name" {
  type        = string
  description = "Your S3 bucketname for backend"
}