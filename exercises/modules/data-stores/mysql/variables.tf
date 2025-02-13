variable "db_username" {
  description = "db username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "db password"
  type        = string
  sensitive   = true
}

variable "cluster_name" {
  description = "name for all cluster resources"
  type        = string
}
