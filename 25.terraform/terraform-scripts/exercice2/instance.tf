resource "aws_instance" "zitouni-inst" {
  ami                    = var.AMIS[var.REGION]
  instance_type          = "t2.micro"
  availability_zone      = var.ZONE1
  key_name               = "dove-key"
  vpc_security_group_ids = ["sg-0429717c6ed36166b"]
  tags = {
    Name    = "Zitouni-Instance"
    Project = "Terraform Tutos"
  }
}