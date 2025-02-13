output "address" {
  value       = module.mysql.address
  description = "db connection endpoint"
}

output "port" {
  description = "port on which database is listening"
  value       = module.mysql.port
}


