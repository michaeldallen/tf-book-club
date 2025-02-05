resource "aws_instance" "ch2-httpd" {

  ami           = "ami-0df8c184d5f6ae949" # Amazon Linux 2 AMI (HVM), SSD Volume Type
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.ch2-web-sg.id]
  subnet_id              = aws_subnet.ch2-pub-sn.id

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              sed -i 's/Listen 80/Listen ${var.server_port}/' /etc/httpd/conf/httpd.conf
              systemctl start httpd
              systemctl enable httpd
              echo "hello, world" > /var/www/html/index.html
              EOF

  user_data_replace_on_change = true

  tags = {
    Name = "ch2-hw"
  }
}


resource "aws_eip" "ch2-httpd-eip" {
  instance = aws_instance.ch2-httpd.id
  domain   = "vpc"

  tags = {
    Name = "ch2-httpd-eip"
  }
}


resource "aws_launch_template" "ch2-httpd-lt" {

  image_id      = "ami-0df8c184d5f6ae949"
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.ch2-web-sg.id]

  user_data = base64encode(<<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              sed -i 's/Listen 80/Listen ${var.server_port}/' /etc/httpd/conf/httpd.conf
              systemctl start httpd
              systemctl enable httpd
              echo "hello, world" > /var/www/html/index.html
              EOF
  )

}

resource "aws_autoscaling_group" "ch2-asg" {

  launch_template {
    id = aws_launch_template.ch2-httpd-lt.id
  }

  min_size            = 2
  max_size            = 10
  vpc_zone_identifier = [aws_subnet.ch2-pub-sn.id]


  tag {
    key                 = "Name"
    value               = "ch2-asg-example"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}


