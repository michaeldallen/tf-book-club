variable "aws_region" {
  description = "The AWS region to host Hello, World"
  default     = "us-east-1"
}

variable "state_storage" {
  description = "Name of AWS S3 bucket for TF state storage"
  default     = "tfbc-state"
}

variable "state_lock_table" {
  description = "Name of DynamoDB table used for TF locks"
  default     = "tfbc-locks"
}


