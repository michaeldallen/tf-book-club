output "server-port" {
  value = var.server_port
}

output "alb-dns-name" {
  value = aws_lb.tfbc-alb.dns_name
}

