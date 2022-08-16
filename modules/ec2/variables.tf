variable "region" {
  type    = string
  default = "us-east-1"
}

variable "instance_type" {
  type = string
  default = "t2.micro"
}

variable "port" {
  type = number
  default = 80
}
variable "vpc_id" {
  type = string
}
variable "subnet_id" {
  type = string
}

variable "tg_arn" {
  type = string
}

variable "security_group_id" {
  type = string
}

variable "ec2_name" {
  type = string
  default = "TERRAFORM-EC2"
}