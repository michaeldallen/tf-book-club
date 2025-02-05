output "public_ip" {
  value       = aws_eip.ch2-httpd-eip.public_ip
  description = "The public IP address of the Hello World instance"
}

output "default-vpc-id" {
  value = data.aws_vpc.default-vpc.id
}


output "default-subnets" { 
  value = data.aws_subnets.default-subnets
}
