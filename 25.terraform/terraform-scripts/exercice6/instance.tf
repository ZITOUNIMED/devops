resource "aws_key_pair" "zitouni-key-pair" {
  key_name   = "zitounikeypar"
  public_key = file("zitouni-key.pub")
}

resource "aws_instance" "zitouni-web" {
  ami                    = var.AMIS[var.REGION]
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.zitouni-pub-1.id
  availability_zone      = var.ZONE1
  key_name               = aws_key_pair.zitouni-key-pair.key_name
  vpc_security_group_ids = [aws_security_group.zitouni_stack_sg.id]
  tags = {
    Name = "Zitouni-Web"
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

resource "aws_ebs_volume" "vol_4_zitouni" {
  availability_zone = var.ZONE1
  size              = 3
  tags = {
    Name = "extra-vol-4-zitouni"
  }
}

resource "aws_volume_attachment" "atch_vol_zitouni" {
  device_name = "/dev/xvdh"
  volume_id   = aws_ebs_volume.vol_4_zitouni.id
  instance_id = aws_instance.zitouni-web.id
}

output "PublicIP" {
  value = aws_instance.zitouni-web.public_ip
}