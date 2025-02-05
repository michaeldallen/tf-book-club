output "public_ip" {
  value       = aws_eip.ch2-httpd-eip.public_ip
  description = "The public IP address of the Hello World instance"
}

output "vpc_id" {
  value       = data.aws_vpc.ch2_vpc.id
  description = "id of chapter 2 vpc"
}


output "subnet_id" {
  value       = data.aws_subnet.ch2_pub_subnet.id
  description = "id of chapter 2 public subnet"
}
