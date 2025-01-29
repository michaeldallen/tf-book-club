
resource "aws_instance" "helloworld-instance" {
  ami           = "ami-0df8c184d5f6ae949"
  instance_type = "t2.micro"

  tags = {
    Name = "mallen-tf-book-club-chapter2-instance"
  }

  user_data = <<-EOF
    #!/bin/bash
    echo "mallen-tf-book-club-chapter2-instance" > index.html
    nohup busybox httpd -f -p ${var.server_port} &
  EOF

  user_data_replace_on_change = true

  vpc_security_group_ids = [aws_security_group.helloworld-security-group.id]

}

