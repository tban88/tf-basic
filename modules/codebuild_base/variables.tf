variable "region" {
  type    = string
  default = "us-east-1"
}

variable "aws_profile" {
  type        = string
  description = "AWS profile"
  default     = "default"
}

variable "aws_account" {
  type = string
}

variable "name" {
  type = string
}

variable "git_repo" {
  type = string
}