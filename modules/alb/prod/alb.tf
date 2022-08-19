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

resource "aws_lb" "prod_lb" {
  name = var.lb_name
  subnets = var.internal == false ? var.prod_pub_subnets : var.prod_prv_subnets
  security_groups = local.prod_default_sg
  internal = var.internal
  load_balancer_type = var.lb_type
}


