provider "aws" {
  region = var.region
}

resource "aws_vpc" "devops_vpc" {
  cidr_block = var.cidr_blocks["vpc"]
}

resource "aws_subnet" "prv-subnetA" {
    vpc_id = aws_vpc.devops_vpc.id
    cidr_block = var.cidr_blocks["priv-subnetA"]
    availability_zone = var.AZ-names["privateA"]
    tags = {
      "name" = var.subnet_tags["privateA"]
    }
}  

resource "aws_subnet" "pub-subnetA" {
    vpc_id = aws_vpc.devops_vpc.id
    cidr_block = var.cidr_blocks["pub-subnetA"]
    availability_zone = var.AZ-names["publicA"]
    tags = {
      "name" = var.subnet_tags["publicA"]
    }
}  
