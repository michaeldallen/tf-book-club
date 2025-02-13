locals {
  server_port  = 8080
  any_port     = 0
  any_protocol = "-1"
  tcp_protocol = "tcp"
  all_ips      = ["0.0.0.0/0"]

  image_id = "ami-0df8c184d5f6ae949"
}

