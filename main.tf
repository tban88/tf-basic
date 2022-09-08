terraform {
  required_version = ">=1.2"
  /*
  backend "s3" {
    bucket = "terraform-devops-sandbox-001"
    key = "terraform/state/terraform.tfstate"
    region = "us-east-1"
    profile = "default"
  }
  */
}

provider "aws" {
  region  = var.main_region
  profile = var.aws_profile
}

locals {

  aws_profile         = "default"
  prod_prv_subnets    = ["${module.vpc.prod_prv_subnet_A_data.id}", "${module.vpc.prod_prv_subnet_B_data.id}"]
  prod_pub_subnets    = ["${module.vpc.prod_pub_subnet_A_data.id}", "${module.vpc.prod_pub_subnet_B_data.id}"]
  nonprod_prv_subnets = ["${module.vpc.nonprod_prv_subnet_A_data.id}", "${module.vpc.nonprod_prv_subnet_B_data.id}"]
  nonprod_pub_subnets = ["${module.vpc.nonprod_pub_subnet_A_data.id}", "${module.vpc.nonprod_pub_subnet_A_data.id}"]

}

#Creates baseline networking resources, for new ones, refer to vpc module 
module "vpc" {
  source      = "./modules/vpc_base"
  region      = var.main_region
  aws_profile = local.aws_profile
}

module "prod_pub_lb" {
  source           = "./modules/alb/prod"
  aws_profile      = local.aws_profile
  prod_prv_subnets = local.prod_prv_subnets
  prod_pub_subnets = local.prod_pub_subnets
  prod_default_sg  = ["${module.vpc.prod_df_sg_data.id}"]
  prod_vpc         = module.vpc.prod_vpc_data.id
  lb_name          = "PROD-WEB-PUBLIC"
  internal         = false
}

module "prod_tg_devops" {
  source          = "./modules/target_group"
  aws_profile     = local.aws_profile
  tg_name         = "DEVOPS-TG"
  port            = 80
  vpc_id          = module.vpc.prod_vpc_data.id
  health_path     = "/"
  health_port     = 80
  health_protocol = "HTTP"
}

module "pub_lb_listener" {
  source      = "./modules/alb/listener"
  aws_profile = local.aws_profile
  lb_arn      = module.prod_pub_lb.lb_arn
  target_arn  = module.prod_tg_devops.tg_arn
}

