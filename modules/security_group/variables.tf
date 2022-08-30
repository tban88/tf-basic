variable "region" {
  type    = string
  default = "us-east-1"
}

variable "aws_profile" {
  type = string
  description = "AWS profile"
  default = "terraform"
}

variable "sg_name" {
    type = string
    description = "Security Group's name"
}

variable "sg_description" {
    type = string
    description = "Security Group's description"
}

variable "vpc_id" {
    type = string
    description = "VPC ID"
}

variable "ingress_object_rules" {
    type = list(object({
        port = number
        description = string
        protocol = string
        cidr_blocks = string
    }))
    description = "Ingress rules for SG, type = object"
}

variable "egress_object_rules" {
    type = list(object({
        port = number
        protocol = string
        cidr_blocks = string 
        ipv6_cidr_blocks = string
    }))
    default = [{
        port = 0
        protocol = "-1"
        cidr_blocks = "0.0.0.0/0"
        ipv6_cidr_blocks = "::/0"
    }]
    description = "Egress rules for SG, type = object"
}