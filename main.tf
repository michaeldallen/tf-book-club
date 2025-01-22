provider "aws" {
  region = "us-east-1"
}


resource "aws_instance" "helloword-instance" {
  ami           = "ami-0df8c184d5f6ae949"
  instance_type = "t2.micro"

  tags = {
    Name = "mallen-tf-book-club-chapter2-instance"
  }

  user_data = <<-EOF
    #!/bin/bash
    echo "biteme" > index.html
    nohup busybox httpd -f -p 8080 &
  EOF

  user_data_replace_on_change = true

vpc_security_group_ids = [aws_security_group.helloword-security-group.id]
}



resource "aws_security_group" "helloword-security-group" {

  name = "mallen-tf-book-club-chapter2-sg"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
