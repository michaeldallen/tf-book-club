output "server-port" {
  value = local.server_port
}

output "alb-dns-name" {
  value = aws_lb.tfbc-alb.dns_name
}

