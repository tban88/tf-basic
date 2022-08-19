######################## TERRAFORM CONFIG ########################

terraform {
  required_version = ">=1.2"
}

######################## PROVIDERS ########################

# Define provided: AWS
provider "aws" {
  region = var.region
}

resource "aws_lb_target_group_attachment" "target_lb_asoc" {
  target_group_arn = var.tg_arn
  target_id        = var.ec2_id
  port             = var.port
}