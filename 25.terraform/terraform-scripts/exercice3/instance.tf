resource "aws_key_pair" "zitouni-key-pair" {
  key_name   = "zitounikeypar"
  public_key = file("zitouni-key.pub")
}

resource "aws_instance" "zitouni-second-instance" {
  ami                    = var.AMIS[var.REGION]
  instance_type          = "t2.micro"
  availability_zone      = var.ZONE1
  key_name               = aws_key_pair.zitouni-key-pair.key_name
  vpc_security_group_ids = ["sg-0429717c6ed36166b"]
  tags = {
    Name    = "Zitouni-Second-Instance"
    Project = "Terraform Tuto 3"
  }

  provisioner "file" {
    source      = "web.sh"
    destination = "/tmp/web.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod u+x /tmp/web.sh",
      "sudo /tmp/web.sh"
    ]
  }

  connection {
    user        = var.USER
    private_key = file("zitouni-key")
    host        = self.public_ip
  }
}