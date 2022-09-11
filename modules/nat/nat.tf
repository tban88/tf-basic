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
nat_name
subnet_id (Needs to be public)
*/

resource "aws_eip" "new_eip" {
  vpc = true
  tags = {
    "Name" = "${upper(var.nat_name)}-EIP"
  }
}

resource "aws_nat_gateway" "new_nat" {
  allocation_id = aws_eip.new_eip.id
  subnet_id     = var.subnet_id
  tags = {
    "Name" = "${upper(var.nat_name)}-NAT"
  }
}