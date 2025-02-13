output "address" {
  value       = aws_db_instance.example.address
  description = "db connection endpoint"
}

output "port" {
  description = "port on which database is listening"
  value       = aws_db_instance.example.port
}


