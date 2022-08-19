variable "region" {
  type    = string
  default = "us-east-1"
  description = "Main region"
}

variable "tg_arn" {
  type = string
  description = "Target Group ARN"
}

variable "ec2_id" {
    type = string
    description = "EC2-ID to bind target group"
}

variable "port" {
    type = number
    description = "Target Group listening port"
    default = 80
}