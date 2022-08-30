variable "region" {
  type    = string
  default = "us-east-1"
}

variable "aws_profile" {
  type = string
  description = "AWS profile"
  default = "terraform"
}

variable "cidr_block" {
    type = string
    description = "VPC CIDR Block"
}

variable "enable_dns_hostnames" {
    type = bool
    description = "Enable DNS hostnames"
    default = true
}

variable "vpc_name" {
    type = string
    description = "VPC Name"
}