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
nat_id

OPTIONAL: DEFAULT
public_ip_onlaunch > false
all_ipv4_cidr > 0.0.0.0/0
all_ipv6_cidr > ::/0
*/

resource "aws_subnet" "new_prv_subnet" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.cidr_block
  availability_zone       = var.az_name
  map_public_ip_on_launch = var.public_ip_onlaunch
  tags = {
    "Name" = "${upper(var.sn_name)}-PRV-SN"
  }
}

resource "aws_route_table" "new_prv_rt" {
  vpc_id = var.vpc_id
  tags = {
    "Name" = "${upper(var.sn_name)}-PRV-RT"
  }
}

resource "aws_route" "rt_rules" {
  route_table_id         = aws_route_table.new_prv_rt.id
  destination_cidr_block = var.all_ipv4_cidr
  #destination_ipv6_cidr_block = var.all_ipv6_cidr
  nat_gateway_id = var.nat_id
}

resource "aws_route_table_association" "new_rt_asoc" {
  subnet_id      = aws_subnet.new_prv_subnet.id
  route_table_id = aws_route_table.new_prv_rt.id
}