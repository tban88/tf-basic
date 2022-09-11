variable "region" {
  type    = string
  default = "us-east-1"
}

variable "aws_profile" {
  type        = string
  description = "AWS profile"
  default     = "default"
}

variable "lb_arn" {
  type        = string
  description = "Load balancer's ARN"
}

variable "port" {
  type        = number
  description = "Listening port for the LB listener"
  default     = 80
}

variable "protocol" {
  type        = string
  description = "Default protocol for the listener"
  default     = "HTTP"
}

variable "action" {
  type        = string
  description = "default action for the listener"
  default     = "forward"
}

variable "target_arn" {
  type        = string
  description = "Target group's ARN to route traffic to"
}