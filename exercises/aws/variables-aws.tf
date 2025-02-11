variable "aws_region" {
  description = "The AWS region to host Hello, World"
  default     = "us-east-1"
}

variable "backend_storage_name" {
  description = "Name of AWS S3 bucket for TF state storage"
  default     = "tf-book-club-state"
}

