variable "REGION" {
  default = "eu-west-3"
}

variable "ZONE1" {
  default = "eu-west-3a"
}

variable "ZONE2" {
  default = "eu-west-3b"
}

variable "ZONE3" {
  default = "eu-west-3c"
}

variable "AMIS" {
  type = map(any)
  default = {
    eu-west-3 = "ami-080fa3659564ffbb1"
    eu-west-1 = "ami-0b995c42184e99f98"
  }
}

variable "USER" {
  default = "ec2-user"
}

variable "PUB_KEY" {
  default = "zitouuni-key.pub"
}

variable "PRIV_KEY" {
  default = "zitouuni-key"
}

variable "MYIP" {
  default = "91.173.69.113/32"
}