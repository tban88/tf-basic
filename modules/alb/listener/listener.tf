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

resource "aws_lb_listener" "new_listener" {
  load_balancer_arn = var.lb_arn
  port = var.port
  protocol = var.protocol
  default_action {
    type = var.action
    target_group_arn = var.target_arn
  }
}