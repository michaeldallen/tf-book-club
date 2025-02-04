variable "server_port" {
  description = "non-privileged port for HTTP server"
  type        = number
  default     = 8080
}

variable "aws_region" {
  description = "The AWS region to create resources in"
  default     = "us-east-1"
}

