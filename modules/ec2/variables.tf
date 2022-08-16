variable "region" {
  type    = string
  default = "us-east-1"
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