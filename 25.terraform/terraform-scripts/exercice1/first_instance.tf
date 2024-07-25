provider "aws" {
  region = "eu-west-3"
}

resource "aws_instance" "intro" {
  ami                    = "ami-080fa3659564ffbb1"
  instance_type          = "t2.micro"
  availability_zone      = "eu-west-3a"
  key_name               = "dove-key"
  vpc_security_group_ids = ["sg-0429717c6ed36166b"]
  tags = {
    Name    = "Dove-Instance"
    Project = "Dave"
  }
}