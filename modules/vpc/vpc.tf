######################## TERRAFORM CONFIG ########################

terraform {
  required_version = ">=1.2"
}

######################## PROVIDERS ########################

# Define provided: AWS
provider "aws" {
  region = var.region
  profile = var.aws_profile
}

resource "aws_vpc" "new_vpc" {
  cidr_block = var.cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  tags = {
    "Name" = "${upper(var.vpc_name)}"
  }
}

resource "aws_internet_gateway" "new_igw" {
  vpc_id = aws_vpc.new_vpc.id
  tags = {
    "Name" = "${upper(var.vpc_name)}-IGW"
  }
}