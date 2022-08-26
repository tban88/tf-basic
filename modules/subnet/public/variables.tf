variable "region" {
  type    = string
  default = "us-east-1"
}

variable "sn_name" {
    type = string
    description = "Subnet name"
}

variable "vpc_id" {
    type = string
    description = "VPC ID"
}

variable "cidr_block" {
    type = string
    description = "Subnet CIDR"
}

variable "az_name" {
    type = string
    description = "Availability Zone"
    default = "us-east-1a"
}

variable "public_ip_onlaunch" {
    type = bool
    description = "Assign public IP by default: true or false"
    default = true
}

variable "igw_id" {
    type = string
    description = "Internet Gateway ID for public routing"
}

variable "all_ipv4_cidr" {
    type = string
    description = "All ipv4 addresses"
    default = "0.0.0.0/0"
}

variable "all_ipv6_cidr" {
    type = string
    description = "All ipv6 addresses"
    default = "::/0"
}