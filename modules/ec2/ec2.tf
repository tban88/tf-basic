######################## TERRAFORM CONFIG ########################

terraform {
  required_version = ">=1.2"
}

######################## PROVIDERS ########################

# Define provided: AWS
provider "aws" {
  region = var.region
}

######################## RESOURCES: PROD ########################

locals {
  ec2_instance = aws_instance.prod_ec2_jenkins.id
}
resource "aws_instance" "prod_ec2_jenkins" {
  ami = "ami-052efd3df9dad4825"
  instance_type = var.instance_type
  associate_public_ip_address = true
  subnet_id = var.subnet_id
  key_name = "test-devops"
  vpc_security_group_ids = ["${var.security_group_id}"]
  user_data = file("./modules/ec2/user_data/jenkins.sh")
  tags = {
    "Name" = var.ec2_name
  }
}

resource "aws_lb_target_group_attachment" "tg_ec2_jenkins_asoc" {
  target_group_arn = var.tg_arn
  target_id        = local.ec2_instance
  port             = var.port
}