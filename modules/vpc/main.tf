provider "aws" {
  region = var.region
}

resource "aws_vpc" "devops_vpc" {
  cidr_block = var.vpc_cidr_range
}

resource "aws_subnet" "prv-subnetA" {
    vpc_id = aws_vpc.devops_vpc.id
    cidr_block = var.cidr_blocks.privateA
    availability_zone = var.AZ-names.privateA
    tags = {
      "name" = var.subnet_tags.privateA
    }
}  

resource "aws_subnet" "pub-subnetA" {
    vpc_id = aws_vpc.devops_vpc.id
    cidr_block = var.cidr_blocks.publicA
    availability_zone = var.AZ-names.publicA
    tags = {
      "name" = var.subnet_tags.publicA
    }
}  
