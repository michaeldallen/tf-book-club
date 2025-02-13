variable "server_port" {
  description = "port for receiving http requests"
  type        = number
  default     = 8080
}


variable "cluster_name" {
  description = "name for all cluster resources"
  type = string
}


variable "db_remote_state_bucket" { 
  description = "database remote state bucket name"
  type = string
}

variable "db_remote_state_key" { 
  description = "database remote state bucket key/path"
  type = string
}

