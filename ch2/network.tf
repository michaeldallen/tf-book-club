data "aws_vpc" "default-vpc" {
  default = true
}


data "aws_subnets" "default-subnets" { 
  filter {
    name = "vpc-id"
    values = [data.aws_vpc.default-vpc.id]
  }
}


resource "aws_security_group" "ch2-web-sg" {
  name        = "allow_http"
  description = "Allow HTTP inbound traffic"
  vpc_id      = data.aws_vpc.default-vpc.id

  ingress {
    description = "HTTP from anywhere"
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ch2-allow_http"
  }
}


