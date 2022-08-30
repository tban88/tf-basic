terraform {
  required_version = ">=1.2"
}

provider "aws" {
  region = var.main_region
  profile = terraform
}

locals {

  prod_prv_subnets = ["${module.vpc.prod_prv_subnet_A_data.id}", "${module.vpc.prod_prv_subnet_B_data.id}"]
  prod_pub_subnets = ["${module.vpc.prod_pub_subnet_A_data.id}", "${module.vpc.prod_pub_subnet_B_data.id}"]
  nonprod_prv_subnets = ["${module.vpc.nonprod_prv_subnet_A_data.id}", "${module.vpc.nonprod_prv_subnet_B_data.id}"]
  nonprod_pub_subnets = ["${module.vpc.nonprod_pub_subnet_A_data.id}", "${module.vpc.nonprod_pub_subnet_A_data.id}"]
  prod_default_sg = ["${module.vpc.prod_df_sg_data.id}"]
  nonprod_default_sg = ["${module.vpc.nonprod_df_sg_data.id}"]
  prod_vpc_id = module.vpc.prod_vpc_data.id
  nonprod_vpc_id = module.vpc.nonprod_vpc_data.id
  jenkins_tg_arn = module.prod_tg_jenkins.tg_arn
  prod_alb_public_arn = module.prod_pub_lb.lb_arn
  pub_lb_dns = module.prod_pub_lb.dns_url

}

#Creates baseline networking resources, for new ones, refer to vpc module 
module "vpc" {
  source = "./modules/vpc_base"
  region = var.main_region
}

module "prod_pub_lb" {
  source = "./modules/alb/prod"
  prod_prv_subnets = local.prod_prv_subnets
  prod_pub_subnets = local.prod_pub_subnets
  prod_default_sg = local.prod_default_sg
  prod_vpc = local.prod_vpc_id
  lb_name = "PROD-WEB-PUBLIC"
  internal = false
}

module "prod_tg_devops" {
  source = "./modules/target_group"
  tg_name = "DEVOPS-TG"
  port = 80
  vpc_id = module.vpc.prod_vpc_data.id
  health_path = "/"
  health_port = 80
  health_protocol = "HTTP"
}

module "pub_lb_listener" {
  source = "./modules/alb/listener"
  lb_arn = module.prod_pub_lb.lb_arn
  target_arn = module.prod_tg_devops.tg_arn
}

