terraform {
  required_version = ">=1.2"
}

provider "aws" {
  region = var.main_region
}

module "vpc" {
  source = "./modules/vpc"
  region = var.main_region
}

module "elb" {
  source = "./modules/alb"
  prod_prv_subnets = ["${module.vpc.prod_prv_subnet_A_data.id}", 
                      "${module.vpc.prod_prv_subnet_B_data.id}"]
  prod_pub_subnets = ["${module.vpc.prod_pub_subnet_A_data.id}",
                      "${module.vpc.prod_pub_subnet_B_data.id}"]
  prod_default_sg = ["${module.vpc.prod_df_sg_data.id}"]
  prod_vpc = module.vpc.prod_vpc_data.id
}