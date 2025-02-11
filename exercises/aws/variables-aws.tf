variable "aws_region" {
  description = "The AWS region to host Hello, World"
  default     = "us-east-1"
}

variable "backend_storage" {
  description = "Name of AWS S3 bucket for TF state storage"
  default     = "tf-book-club-state"
}

variable "backend_lock_table" {
  description = "Name of DynamoDB table used for TF locks"
  default     = "tf-book-club-locks"
}


