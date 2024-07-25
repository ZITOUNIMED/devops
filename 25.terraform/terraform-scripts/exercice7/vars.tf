variable "REGION" {
  default = "eu-west-3"
}

variable "clusterName" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "vpro-eks"
}
