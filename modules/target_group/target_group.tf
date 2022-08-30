######################## TERRAFORM CONFIG ########################

terraform {
  required_version = ">=1.2"
}

######################## PROVIDERS ########################

# Define provided: AWS
provider "aws" {
  region = var.region
  profile = var.aws_profile
}

resource "aws_lb_target_group" "new_tg" {
  name     = var.tg_name
  port     = var.port
  protocol = var.protocol
  vpc_id   = var.vpc_id
  deregistration_delay = var.deresgistration_delay
  target_type = var.target_type
  health_check {
    port     = var.health_port
    protocol = var.health_protocol
    path = var.health_path
  }
}