variable "server_port" {
  description = "port for receiving http requests"
  type        = number
  default     = 8080
}

variable "backend_storage_key" {
  description = "Name of storage key used for TF state"
  default     = "global/s3/terraform.tfstate"
}


