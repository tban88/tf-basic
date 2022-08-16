######################## TERRAFORM CONFIG ########################

terraform {
  required_version = ">=1.2"
}

######################## PROVIDERS ########################

# Define provided: AWS
provider "aws" {
  region = var.region
}

######################## LOCALS: PROD ########################

locals {
  prod_prv_subnets = var.prod_prv_subnets
  prod_pub_subnets = var.prod_pub_subnets
  prod_default_sg = var.prod_default_sg
  prod_vpc = var.prod_vpc
}

######################## RESOURCES: PROD ########################

resource "aws_lb" "prod_pub_alb" {
  name = "PROD-WEB-PUBLIC"
  subnets = local.prod_pub_subnets
  security_groups = local.prod_default_sg
  internal = false
  load_balancer_type = "application"
}

resource "aws_lb_target_group" "prod_pub_jenkins_tg" {
  name     = "JENKINS-TG"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = local.prod_vpc
  deregistration_delay = 10
  target_type = "instance"
  health_check {
    port     = 8080
    protocol = "HTTP"
    path = "/login"
  }
}

resource "aws_lb_listener" "prod_pub_alb_listener_jenkins" {
  load_balancer_arn = aws_lb.prod_pub_alb.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.prod_pub_jenkins_tg.arn
  }
}
