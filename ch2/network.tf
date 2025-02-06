data "aws_vpc" "default-vpc" {
  default = true
}


data "aws_subnets" "default-subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default-vpc.id]
  }
}


resource "aws_security_group" "ch2-http-sg" {

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

resource "aws_lb" "ch2-alb" {
  name               = "ch2-alb"
  load_balancer_type = "application"
  subnets            = data.aws_subnets.default-subnets.ids
  security_groups    = [aws_security_group.ch2-http-sg.id]
}


resource "aws_lb_listener" "ch2-alb-http-listener" {
  load_balancer_arn = aws_lb.ch2-alb.arn
  port              = var.server_port
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found, dog"
      status_code  = 404
    }
  }
}




resource "aws_lb_target_group" "ch2-alb-tg" {
  name     = "ch2-alb-tg"
  port     = var.server_port
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default-vpc.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener_rule" "ch2-alb-rule" {
  listener_arn = aws_lb_listener.ch2-alb-http-listener.arn
  priority     = 100
  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ch2-alb-tg.arn
  }
}


