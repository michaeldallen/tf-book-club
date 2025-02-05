data "aws_vpc" "ch2_vpc" {
  filter {
    name   = "tag:Name"
    values = ["ch2-vpc"]
  }
}

data "aws_subnet" "ch2_pub_subnet" {
  vpc_id = data.aws_vpc.ch2_vpc.id

  filter {
    name   = "tag:Name"
    values = ["ch2-pub-sn"]
  }
}

resource "aws_vpc" "ch2-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "ch2-vpc"
  }
}


resource "aws_internet_gateway" "ch2-igw" {
  vpc_id = aws_vpc.ch2-vpc.id

  tags = {
    Name = "ch2-igw"
  }
}


resource "aws_subnet" "ch2-pub-sn" {
  vpc_id                  = aws_vpc.ch2-vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "${var.aws_region}a"

  tags = {
    Name = "ch2-pub-sn"
  }
}




resource "aws_route_table" "ch2-pub-rt" {
  vpc_id = aws_vpc.ch2-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ch2-igw.id
  }

  tags = {
    Name = "ch2-pub-rt"
  }
}




resource "aws_route_table_association" "ch2-pub-rt" {
  subnet_id      = aws_subnet.ch2-pub-sn.id
  route_table_id = aws_route_table.ch2-pub-rt.id
}




resource "aws_security_group" "ch2-web-sg" {
  name        = "allow_http"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.ch2-vpc.id

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

