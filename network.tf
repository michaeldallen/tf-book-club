

resource "aws_security_group" "hello-world-security-group" {

  name = "hello-world-security-group"

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}


resource "aws_vpc" "hello-world-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "hello-world-vpc"
  }
}



resource "aws_subnet" "hello-world-public-subnet" {
  vpc_id                  = aws_vpc.hello-world-vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "${var.aws_region}a"

  tags = {
    Name = "hello-world-public-subnet"
  }
}


resource "aws_internet_gateway" "hello-world-igw" {
    vpc_id = aws_vpc.hello-world-vpc.id

      tags = {
            Name = "hello-world-igw"
              }
            }

resource "aws_route_table" "hello-world-public-rt" {
  vpc_id = aws_vpc.hello-world-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.hello-world-igw.id
  }

  tags = {
    Name = "hello-world-public-rt"
  }
}


resource "aws_route_table_association" "hello-world-public-rt-assoc" {
  subnet_id      = aws_subnet.hello-world-public-subnet.id
  route_table_id = aws_route_table.hello-world-public-rt.id
}

