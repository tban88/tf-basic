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

resource "aws_instance" "prod_ec2_jenkins" {
  ami = "ami-052efd3df9dad4825"
  instance_type = "t2.micro"
  associate_public_ip_address = true
  subnet_id = var.subnet_id
  key_name = "test-devops"
  vpc_security_group_ids = ["${var.security_group_id}"]
  user_data = file("./modules/ec2/user_data/jenkins.sh")
}

resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = var.tg_arn
  target_id        = aws_instance.prod_ec2_jenkins.id
  port             = 8080
}