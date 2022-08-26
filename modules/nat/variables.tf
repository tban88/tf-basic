variable "region" {
  type    = string
  default = "us-east-1"
}

variable "nat_name" {
    type = string
    description = "NAT's name"
}

variable "subnet_id" {
    type = string
    description = "Public subnet ID"
}