output "server-port" {
  value = local.server_port
}

output "alb-dns-name" {
  value = aws_lb.tfbc-alb.dns_name
}


output "alb-security-group-id" {
  description = "ID of security group attached to load balancer"
  value       = aws_security_group.tfbc-sg.id
}

