resource "aws_instance" "ch2-httpd" {

  ami           = "ami-0df8c184d5f6ae949" # Amazon Linux 2 AMI (HVM), SSD Volume Type
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.ch2-web-sg.id]
  subnet_id              = aws_subnet.ch2-pub-sn.id

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Hello, World!</h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name = "HelloWorld"
  }
}


resource "aws_eip" "ch2-httpd-eip" {
  instance = aws_instance.ch2-httpd.id
  domain   = "vpc"

  tags = {
    Name = "ch2-httpd-eip"
  }
}
