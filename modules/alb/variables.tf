######################## INCOMING PARAMETERS ########################

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "prod_prv_subnets" {
  type = list
}

variable "prod_pub_subnets" {
  type = list
}

variable "prod_default_sg" {
  type = list
}

variable "prod_vpc" {
  type = string
}
