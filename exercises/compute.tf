resource "aws_launch_template" "ch2-httpd-lt" {

  name_prefix   = "ch2-"
  image_id      = "ami-0df8c184d5f6ae949"
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.ch2-http-sg.id]

  user_data = base64encode(<<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              sed -i 's/Listen 80/Listen ${var.server_port}/' /etc/httpd/conf/httpd.conf
              systemctl start httpd
              systemctl enable httpd
              echo "word, ch2" > /var/www/html/index.html
              EOF
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "ch2-asg" {

  launch_template {
    id      = aws_launch_template.ch2-httpd-lt.id
    version = aws_launch_template.ch2-httpd-lt.latest_version

  }

  min_size            = 2
  max_size            = 10
  vpc_zone_identifier = data.aws_subnets.default-subnets.ids

  target_group_arns = [aws_lb_target_group.ch2-alb-tg.arn]
  health_check_type = "ELB"

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
  }

  tag {
    key                 = "Name"
    value               = "ch2-asg-example"
    propagate_at_launch = true
  }

}


