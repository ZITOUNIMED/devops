terraform {
    backend "s3" {
        bucket = "terra-state-zitouni"
        key = "terraform/backend"
        region = "eu-west-3"
    }
}