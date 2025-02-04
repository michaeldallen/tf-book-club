output "public_ip" {
  description = "public IP of book club server"
  value       = aws_instance.hello-world-instance.public_ip

}
