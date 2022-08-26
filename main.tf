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
  jenkins_tg_arn = module.prod_tg_jenkins.tg_arn
  prod_alb_public_arn = module.prod_pub_lb.lb_arn
  pub_lb_dns = module.prod_pub_lb.dns_url

  #To use in SG ingress/egress rules (Dynamic Blocks)
  sg_ingress = [{
    port = 80
    description = "SG Description - test"
    protocol = "tcp"
    cidr_blocks = "0.0.0.0/0"
  },
  {
    port = 443
    description = "SG Description - test"
    protocol = "tcp"
    cidr_blocks = "0.0.0.0/0"
  }]

  sg_egress = [{
    port = 0
    protocol = "-1"
    cidr_blocks = "0.0.0.0/0"
    ipv6_cidr_blocks = "::/0"
  }]
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

module "prod_tg_jenkins" {
  source = "./modules/target_group"
  tg_name = "JENKINS-TG"
  port = 8080
  vpc_id = module.vpc.prod_vpc_data.id
  health_path = "/login"
  health_port = 8080
  health_protocol = "HTTP"
}

module "pub_lb_listener" {
  source = "./modules/alb/listener"
  lb_arn = module.prod_pub_lb.lb_arn
  target_arn = module.prod_tg_jenkins.tg_arn
}

module "ec2-jenkins" {
  source = "./modules/ec2"
  vpc_id = module.vpc.prod_vpc_data.id
  subnet_id = module.vpc.prod_pub_subnet_A_data.id
  security_group_id = module.vpc.prod_df_sg_data.id
  ami_id = "ami-052efd3df9dad4825" #ubuntu 22.04
  user_data = "./modules/ec2/user_data/jenkins.sh"
  ec2_name = "JENKINS"
  public_ip = true
}

module "ec2-jenkins-prv" {
  source = "./modules/ec2"
  vpc_id = module.vpc.prod_vpc_data.id
  subnet_id = module.vpc.prod_prv_subnet_B_data.id
  security_group_id = module.vpc.prod_df_sg_data.id
  ami_id = "ami-052efd3df9dad4825" #ubuntu 22.04
  #user_data = "./modules/ec2/user_data/jenkins.sh"
  ec2_name = "JENKINS-PRV"
  public_ip = false
}

module "jenkins_tg_asoc" {
  source = "./modules/target_asoc"
  tg_arn = module.prod_tg_jenkins.tg_arn
  ec2_id = module.ec2-jenkins.ec2_id
  port = 8080
}

module "ec2-openvpn" {
  source = "./modules/ec2"
  vpc_id = module.vpc.prod_vpc_data.id
  subnet_id = module.vpc.prod_pub_subnet_A_data.id
  security_group_id = module.vpc.prod_df_sg_data.id
  ami_id = "ami-08d4ac5b634553e16" #ubuntu 20.04
  user_data = "./modules/ec2/user_data/openvpn.sh"
  ec2_name = "OPENVPN"
  public_ip = true
}

## TEST BLOCKS

module "new_vpc" {
  source = "./modules/vpc"
  cidr_block = "192.168.0.0/16"
  vpc_name = "devops"
}

module "test-sg" {
  source = "./modules/security_group"
  sg_name = "test-DEVOPS"
  sg_description = "Devops test security group"
  vpc_id = module.new_vpc.vpc_id
  ingress_object_rules = local.sg_ingress
  egress_object_rules = local.sg_egress
}
module "test-subnet-pub" {
  source = "./modules/subnet/public"
  sn_name = "test-public"
  vpc_id = module.new_vpc.vpc_id
  cidr_block = "192.168.100.0/24"
  az_name = "us-east-1c"
  igw_id = module.new_vpc.igw_id
}

module "new_nat" {
  source = "./modules/nat"
  nat_name = "test"
  subnet_id = module.test-subnet-pub.subnet_id
}

module "test-subnet-prv" {
  source = "./modules/subnet/private"
  sn_name = "test-private"
  vpc_id = module.new_vpc.vpc_id
  cidr_block = "192.168.200.0/24"
  az_name = "us-east-1c"
  nat_id = module.new_nat.nat_id
}