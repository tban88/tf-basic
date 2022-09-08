variable "region" {
  type    = string
  default = "us-east-1"
}

variable "aws_profile" {
  type = string
  description = "AWS profile"
  default = "default"
}

variable "nat_name" {
    type = string
    description = "NAT's name"
}

variable "subnet_id" {
    type = string
    description = "Public subnet ID"
}