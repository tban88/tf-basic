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

######################## RESOURCES: PROD ########################

resource "aws_instance" "new_ec2" {
  ami = var.ami_id
  instance_type = var.instance_type
  associate_public_ip_address = var.public_ip
  subnet_id = var.subnet_id
  key_name = var.key_pair
  vpc_security_group_ids = ["${var.security_group_id}"]
  user_data = file("${var.user_data}")
  tags = {
    "Name" = var.ec2_name
  }
}

