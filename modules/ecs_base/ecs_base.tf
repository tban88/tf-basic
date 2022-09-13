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

resource "aws_ecs_cluster" "new_ecs" {
  name = var.name

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}