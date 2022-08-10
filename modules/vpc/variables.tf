variable "region" {
  type    = string
  default = "us-east-1"
}

variable "cidr_blocks" {
    type = map
    default = {
        "vpc" = "10.10.0.0/16"
        "priv-subnetA" = "10.10.0.0/24"
        "priv-subnetB" = "10.10.1.0/24"
        "pub-subnetA" = "10.10.2.0/24"
        "pub-subnetB" = "10.10.3.0/24"
    }
}

variable "AZ-names" {
    type = map
    default = {
        "privateA" = "us-east-1a"
        "privateB" = "us-east-1b"
        "publicA" = "us-east-1a"
        "publicB" = "us-east-1b"
    }
}

variable "subnet_tags" {
    type = map
    default = {
        "privateA" = "PROD-PRIV-A"
        "privateB" = "PROD-PRIV-B"
        "publicA" = "PROD-PUB-A"
        "publicB" = "PROD-PUB-B" 
    }

}