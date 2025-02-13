//variable "server_port" {
//  description = "port for receiving http requests"
//  type        = number
//  default     = 8080
//}


variable "cluster_name" {
  description = "name for all cluster resources"
  type        = string
}


variable "db_remote_state_bucket" {
  description = "database remote state bucket name"
  type        = string
}

variable "db_remote_state_key" {
  description = "database remote state bucket key/path"
  type        = string
}

variable "instance_type" {
  description = "the type of EC2 instance to run"
  type        = string
}

variable "min_size" {
  description = "the minimum number of EC2 instances in the ASG"
  type        = number
}

variable "max_size" {
  description = "the maximum number of EC2 instances in the ASG"
  type        = number
}

