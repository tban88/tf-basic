terraform {
  required_version = ">=1.2"
}

provider "aws" {
  region = var.main_region
}
/*
data "aws_security_group" "prod_default_sg" {
  filter {
    name = "tag:Name"
    values = ["PROD-DEFAULT-SG"]
  }
}

data "aws_subnet" "data_prod_pub_subnet_A_id" {
  filter {
    name = "tag:Name"
    values = ["PROD-PUB-SN-A"]
  }
}
*/
locals {
  prod_prv_subnets = ["${module.vpc.prod_prv_subnet_A_data.id}", "${module.vpc.prod_prv_subnet_B_data.id}"]
  prod_pub_subnets = ["${module.vpc.prod_pub_subnet_A_data.id}", "${module.vpc.prod_pub_subnet_B_data.id}"]
  nonprod_prv_subnets = ["${module.vpc.nonprod_prv_subnet_A_data.id}", "${module.vpc.nonprod_prv_subnet_B_data.id}"]
  nonprod_pub_subnets = ["${module.vpc.nonprod_pub_subnet_A_data.id}", "${module.vpc.nonprod_pub_subnet_A_data.id}"]
  prod_default_sg = ["${module.vpc.prod_df_sg_data.id}"]
  nonprod_default_sg = ["${module.vpc.nonprod_df_sg_data.id}"]
  prod_vpc_id = module.vpc.prod_vpc_data.id
  nonprod_vpc_id = module.vpc.nonprod_vpc_data.id
  jenkins_tg_arn = module.alb.jenkins_tg_arn
  prod_alb_public_arn = module.alb.prod_alb_public_arn 
}

module "vpc" {
  source = "./modules/vpc"
  region = var.main_region
}

module "alb" {
  source = "./modules/alb"
  prod_prv_subnets = local.prod_prv_subnets
  prod_pub_subnets = local.prod_pub_subnets
  prod_default_sg = local.prod_default_sg
  prod_vpc = local.prod_vpc_id
}

module "ec2-jenkins" {
  source = "./modules/ec2"
  vpc_id = local.prod_vpc_id
  subnet_id = module.vpc.prod_pub_subnet_A_data.id
  #subnet_id = data.aws_subnet.data_prod_pub_subnet_A_id.id
  tg_arn = module.alb.jenkins_tg_arn
  security_group_id = module.vpc.prod_df_sg_data.id
  #security_group_id = data.aws_security_group.prod_default_sg.id
}