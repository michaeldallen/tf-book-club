variable "aws_region" {
  description = "The AWS region to host Hello, World"
  default     = "us-east-1"
}

variable "server_port" {
  description = "port for receiving http requests"
  type        = number
  default     = 8080
}
