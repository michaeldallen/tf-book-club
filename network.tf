

resource "aws_security_group" "helloworld-security-group" {

  name = "mallen-tf-book-club-chapter2-sg"

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}


