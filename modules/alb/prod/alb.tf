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

######################## RESOURCES: PROD ########################

resource "aws_lb" "prod_lb" {
  name = var.lb_name
  subnets = var.internal == false ? var.prod_pub_subnets : var.prod_prv_subnets
  security_groups = var.prod_default_sg
  internal = var.internal
  load_balancer_type = var.lb_type
}


