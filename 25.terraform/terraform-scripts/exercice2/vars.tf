variable "REGION" {
  default = "eu-west-3"
}

variable "ZONE1" {
  default = "eu-west-3a"
}

variable "AMIS" {
  type = map(any)
  default = {
    eu-west-3 = "ami-080fa3659564ffbb1"
    eu-west-1 = "ami-0b995c42184e99f98"
  }
}