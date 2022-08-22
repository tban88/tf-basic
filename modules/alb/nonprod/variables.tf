######################## INCOMING PARAMETERS ########################

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "internal" {
    type = bool
    description = "LB is private or not | true = internal | false = public"
    default = false
}

variable "lb_name" {
    type = string
    description = "LB's name"
}

variable "lb_type" {
  type = string
  description = "LB type: gateway, application, network"
  default = "application"
}

variable "nonprod_prv_subnets" {
  type = list
}

variable "nonprod_pub_subnets" {
  type = list
}

variable "nonprod_default_sg" {
  type = list
}

variable "nonprod_vpc" {
  type = string
}
