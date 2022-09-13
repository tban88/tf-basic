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

resource "aws_key_pair" "new_key_pair" {
  key_name   = var.key_name
  public_key = var.pub_key_path
}