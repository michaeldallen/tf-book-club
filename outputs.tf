output "public_ip" {
  description = "public IP of book club server"
  value       = aws_instance.helloworld-instance.public_ip
}
