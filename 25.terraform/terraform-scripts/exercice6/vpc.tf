resource "aws_vpc" "zitouni-vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name = "vprofile"
  }
}

resource "aws_subnet" "zitouni-pub-1" {
  vpc_id                  = aws_vpc.zitouni-vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = var.ZONE1
  tags = {
    Name = "zitouni-pub-1"
  }
}

resource "aws_subnet" "zitouni-pub-2" {
  vpc_id                  = aws_vpc.zitouni-vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = var.ZONE2
  tags = {
    Name = "zitouni-pub-2"
  }
}

resource "aws_subnet" "zitouni-pub-3" {
  vpc_id                  = aws_vpc.zitouni-vpc.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = var.ZONE3
  tags = {
    Name = "zitouni-pub-3"
  }
}

resource "aws_subnet" "zitouni-priv-1" {
  vpc_id                  = aws_vpc.zitouni-vpc.id
  cidr_block              = "10.0.4.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = var.ZONE1
  tags = {
    Name = "zitouni-priv-1"
  }
}

resource "aws_subnet" "zitouni-priv-2" {
  vpc_id                  = aws_vpc.zitouni-vpc.id
  cidr_block              = "10.0.5.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = var.ZONE2
  tags = {
    Name = "zitouni-priv-2"
  }
}

resource "aws_subnet" "zitouni-priv-3" {
  vpc_id                  = aws_vpc.zitouni-vpc.id
  cidr_block              = "10.0.6.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = var.ZONE3
  tags = {
    Name = "zitouni-priv-3"
  }
}

resource "aws_internet_gateway" "zitouni-IGW" {
  vpc_id = aws_vpc.zitouni-vpc.id
  tags = {
    Name = "zitouni-IGW"
  }
}

resource "aws_route_table" "zitouni-pub-RT" {
  vpc_id = aws_vpc.zitouni-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.zitouni-IGW.id
  }

  tags = {
    Name = "zitouni-RT"
  }
}

resource "aws_route_table_association" "zitouni-pub-1-a" {
  subnet_id      = aws_subnet.zitouni-pub-1.id
  route_table_id = aws_route_table.zitouni-pub-RT.id
}

resource "aws_route_table_association" "zitouni-pub-2-a" {
  subnet_id      = aws_subnet.zitouni-pub-2.id
  route_table_id = aws_route_table.zitouni-pub-RT.id
}

resource "aws_route_table_association" "zitouni-pub-3-a" {
  subnet_id      = aws_subnet.zitouni-pub-3.id
  route_table_id = aws_route_table.zitouni-pub-RT.id
}