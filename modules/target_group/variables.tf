######################## INCOMING PARAMETERS ########################

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "tg_name" {
    type = string
    description = "Target group's name"
}

variable "port" {
    type = number
    description = "default TG port"
    default = 80
}

variable "protocol" {
    type = string
    description = "TG's default prototocl"
    default = "HTTP"
}

variable "vpc_id" {
    type = string
    description = "VPC ID where the TG will be created"
}

variable "target_type" {
    type = string
    description = "Type of hosts that the TG will be hosting: instance, IP, etc"
    default = "instance"
}

variable "health_path" {
    type = string
    description = "Default path for the health checks"
}

variable "health_port" {
    type = number
    description = "Default path for the health checks"
    default = 80
}

variable "health_protocol" {
    type = string
    description = "Default health check protocol"
    default = "HTTP"
}

variable "deresgistration_delay" {
    type = number
    description = "Draining delay time"
    default = 10
}