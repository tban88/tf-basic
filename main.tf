terraform {
  required_version = ">=1.2"
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
  target_type     = "ip"
}

module "pub_lb_listener" {
  source      = "./modules/alb/listener"
  aws_profile = local.aws_profile
  lb_arn      = module.prod_pub_lb.lb_arn
  target_arn  = module.prod_tg_devops.tg_arn
}

module "ec2-jenkins" {
  source            = "./modules/ec2"
  user_data         = "./modules/ec2/user_data/jenkins.sh"
  ami_id            = "ami-052efd3df9dad4825"
  instance_type     = "t2.medium"
  public_ip         = true
  subnet_id         = module.vpc.prod_pub_subnet_A_data.id
  key_pair          = "test-devops"
  vpc_id            = module.vpc.prod_vpc_data.id
  security_group_id = module.vpc.prod_df_sg_data.id
  ec2_name          = "Jenkins"
  aws_profile       = var.aws_profile
}

###### TEST
module "codebuild1" {
  source      = "./modules/codebuild_base"
  git_repo    = "null"
  aws_account = "219545058254"
  name        = "gorito-site"
}

## https://github.com/terraform-aws-modules/terraform-aws-ecr
module "ecr" {
  source = "./modules/ecr_base"
  name   = "gorito-site"
}

module "secret" {
  source = "./modules/secrets_base"
  name   = "dockerhub/credentials"

}

module "ecs_cluster" {
  source = "./modules/ecs_base"
  name   = "prod"
}

/*
1. set keypair
2. set credentials in secret manager
3. deploy TF
*/