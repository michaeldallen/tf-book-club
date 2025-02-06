output "default-vpc-id" {
  value = data.aws_vpc.default-vpc.id
}


output "default-subnets" {
  value = data.aws_subnets.default-subnets
}

output "server-port" {
  value = var.server_port
}

output "alb-dns-name" {
  value = aws_lb.ch2-alb.dns_name
}

output "launch-template-version" {
  value = aws_launch_template.ch2-httpd-lt.latest_version
}

