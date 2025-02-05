output "public_ip" {
  value       = aws_eip.ch2-httpd-eip.public_ip
  description = "The public IP address of the Hello World instance"
}
