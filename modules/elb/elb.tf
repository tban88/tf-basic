terraform {
  required_version = ">=1.2"
}

provider "aws" {
  region = var.main_region
}

