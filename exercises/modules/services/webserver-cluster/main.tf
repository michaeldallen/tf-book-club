data "terraform_remote_state" "db" {
  backend = "s3"
  config = {
    bucket = "${var.db_remote_state_bucket}"
    key    = "${var.db_remote_state_key}"
    region = "us-east-1"
  }
}


resource "aws_launch_template" "tfbc-lt" {

  name_prefix   = "${var.cluster_name}-"
  image_id      = "ami-0df8c184d5f6ae949"
  instance_type = "${var.instance_type}"

  vpc_security_group_ids = [aws_security_group.tfbc-sg.id]

  user_data = base64encode(templatefile("${path.module}/user-data.sh", {
    server_port = var.server_port
    cluster_name = var.cluster_name
    db_address  = data.terraform_remote_state.db.outputs.address
    db_port     = data.terraform_remote_state.db.outputs.port
  }))

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "tfbc-asg" {

  launch_template {
    id      = aws_launch_template.tfbc-lt.id
    version = aws_launch_template.tfbc-lt.latest_version

  }

  min_size            = var.min_size
  max_size            = var.max_size

  vpc_zone_identifier = data.aws_subnets.default-subnets.ids

  target_group_arns = [aws_lb_target_group.tfbc-tg.arn]
  health_check_type = "ELB"

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
  }

  tag {
    key                 = "Name"
    value               = "${var.cluster_name}-asg"
    propagate_at_launch = true
  }

}


data "aws_vpc" "default-vpc" {
  default = true
}


data "aws_subnets" "default-subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default-vpc.id]
  }
}


resource "aws_security_group" "tfbc-sg" {

  name        = "${var.cluster_name}-sg"
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
    Name = "${var.cluster_name}-sg"
  }
}

resource "aws_lb" "tfbc-alb" {
  name               = "${var.cluster_name}-alb"
  load_balancer_type = "application"
  subnets            = data.aws_subnets.default-subnets.ids
  security_groups    = [aws_security_group.tfbc-sg.id]
}


resource "aws_lb_listener" "tfbc-listener" {
  load_balancer_arn = aws_lb.tfbc-alb.arn
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




resource "aws_lb_target_group" "tfbc-tg" {
  name     = "${var.cluster_name}-tg"
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

resource "aws_lb_listener_rule" "tfbc-rule" {
  listener_arn = aws_lb_listener.tfbc-listener.arn
  priority     = 100
  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tfbc-tg.arn
  }
}


