terraform {
  backend "s3" {
    bucket = "terra-state-zitouni"
    key    = "terraform/backend_exercice6"
    region = "eu-west-3"
  }
}