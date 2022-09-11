######################## TERRAFORM CONFIG ########################

terraform {
  required_version = ">=1.2"
}

######################## PROVIDERS ########################

# Define provided: AWS
provider "aws" {
  region  = var.region
  profile = var.aws_profile
}

/*
REQUIRED PARAMETERS 
sn_name
vpc_id
cidr_block
az_name
igw_id

OPTIONAL: DEFAULT
public_ip_onlaunch > true
all_ipv4_cidr > 0.0.0.0/0
all_ipv6_cidr > ::/0
*/

resource "aws_subnet" "new_pub_subnet" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.cidr_block
  availability_zone       = var.az_name
  map_public_ip_on_launch = var.public_ip_onlaunch
  tags = {
    "Name" = "${upper(var.sn_name)}-PUB-SN"
  }
}

resource "aws_route_table" "new_pub_rt" {
  vpc_id = var.vpc_id
  tags = {
    "Name" = "${upper(var.sn_name)}-PUB-RT"
  }
}

resource "aws_route" "rt_rules" {
  route_table_id         = aws_route_table.new_pub_rt.id
  destination_cidr_block = var.all_ipv4_cidr
  #destination_ipv6_cidr_block = var.all_ipv6_cidr
  gateway_id = var.igw_id
}

resource "aws_route_table_association" "new_rt_asoc" {
  subnet_id      = aws_subnet.new_pub_subnet.id
  route_table_id = aws_route_table.new_pub_rt.id
}