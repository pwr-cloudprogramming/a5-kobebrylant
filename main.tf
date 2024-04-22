terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.1"
    }
  }
  required_version = ">= 1.2.0"
}
provider "aws" {
  region = "us-east-1"
}
resource "aws_vpc" "tictactoe_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "TicTacToeVPC"
  }
}

resource "aws_subnet" "tictactoe_subnet" {
  vpc_id            = aws_vpc.tictactoe_vpc.id
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"
  tags = {
    Name = "TicTacToeSubnet"
  }
}


resource "aws_internet_gateway" "tictactoe_igw" {
  vpc_id = aws_vpc.tictactoe_vpc.id
  tags = {
    Name = "TicTacToeIGW"
  }
}

resource "aws_route_table" "tictactoe_rt" {
  vpc_id = aws_vpc.tictactoe_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tictactoe_igw.id
  }
  tags = {
    Name = "TicTacToeRouteTable"
  }
}

resource "aws_route_table_association" "tictactoe_rta" {
  subnet_id      = aws_subnet.tictactoe_subnet.id
  route_table_id = aws_route_table.tictactoe_rt.id
}
resource "aws_security_group" "tictactoe_sg" {
  name        = "TicTacToeSG"
  description = "Security Group for TicTacToe app"
  vpc_id      = aws_vpc.tictactoe_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8081
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
    Name = "TicTacToeSG"
  }
}

resource "aws_instance" "tictactoe_instance" {
  ami           = "ami-080e1f13689e07408"
  instance_type = "t2.micro"
  key_name = "vockey"
  subnet_id     = aws_subnet.tictactoe_subnet.id
  associate_public_ip_address = "true"
  vpc_security_group_ids = [aws_security_group.tictactoe_sg.id]
  
  user_data = file("${path.module}/user-data.sh")
                
  tags = {
    Name = "TicTacToeInstance"
  }
}