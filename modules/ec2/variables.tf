variable "region" {
  type    = string
  default = "us-east-1"
}

variable "aws_profile" {
  type        = string
  description = "AWS profile"
  default     = "default"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "vpc_id" {
  type = string
}
variable "subnet_id" {
  type = string
}

variable "security_group_id" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "public_ip" {
  type    = bool
  default = false
}

variable "key_pair" {
  type    = string
  default = "test-devops"
}

variable "user_data" {
  type    = string
  default = "./modules/ec2/user_data/default.sh"
}

variable "ec2_name" {
  type    = string
  default = "TERRAFORM-EC2"
}