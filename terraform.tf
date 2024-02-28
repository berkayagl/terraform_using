terraform {
  backend {
    bucket         = "my-terraform-bucket"
    key            = "terraform.state"
    region         = "us-east-1"
  }
}

provider "aws" {
 region = "us-east-1"
}

resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "example" {
  vpc_id                  = aws_vpc.example.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = false
}

resource "aws_instance" "example" {
  ami             = "ami-058face4ac718403d"
  instance_type   = "t2.nano"
  subnet_id       = aws_subnet.example.id
}