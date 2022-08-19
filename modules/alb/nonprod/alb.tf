######################## TERRAFORM CONFIG ########################

terraform {
  required_version = ">=1.2"
}

######################## PROVIDERS ########################

# Define provided: AWS
provider "aws" {
  region = var.region
}

######################## RESOURCES: PROD ########################

resource "aws_lb" "nonprod_lb" {
  name = var.lb_name
  subnets = var.internal == false ? var.nonprod_pub_subnets : var.nonprod_prv_subnets
  security_groups = local.nonprod_default_sg
  internal = var.internal
  load_balancer_type = var.lb_type
}


