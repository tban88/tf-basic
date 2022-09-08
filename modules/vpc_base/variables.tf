variable "region" {
  type    = string
  default = "us-east-1"
}

variable "aws_profile" {
  type = string
  description = "AWS profile"
  default = "default"
}

variable "prod_vpc_tags" {
  type = object({
    Name = string
    Environment = string
  })
  default = {
    Name = "PROD-VPC"
    Environment = "PROD"
  }
}

variable "nonprod_vpc_tags" {
  type = object({
    Name = string
    Environment = string
  })
  default = {
    Name = "NONPROD-VPC"
    Environment = "NONPROD"
  }
}

variable "prod_prv_subnet_A_tags" {
  type = object({
    Name = string
    Environment = string
  })
  default = {
    Name = "PROD-PRIV-SN-A"
    Environment = "PROD"
  }
}

variable "prod_prv_subnet_B_tags" {
  type = object({
    Name = string
    Environment = string
  })
  default = {
    Name = "PROD-PRIV-SN-B"
    Environment = "PROD"
  }
}

variable "prod_pub_subnet_A_tags" {
  type = object({
    Name = string
    Environment = string
  })
  default = {
    Name = "PROD-PUB-SN-A"
    Environment = "PROD"
  }
}

variable "prod_pub_subnet_B_tags" {
  type = object({
    Name = string
    Environment = string
  })
  default = {
    Name = "PROD-PUB-SN-B"
    Environment = "PROD"
  }
}

variable "nonprod_prv_subnet_A_tags" {
  type = object({
    Name = string
    Environment = string
  })
  default = {
    Name = "NONPROD-PRIV-SN-A"
    Environment = "NONPROD"
  }
}

variable "nonprod_prv_subnet_B_tags" {
  type = object({
    Name = string
    Environment = string
  })
  default = {
    Name = "NONPROD-PRIV-SN-B"
    Environment = "NONPROD"
  }
}

variable "nonprod_pub_subnet_A_tags" {
  type = object({
    Name = string
    Environment = string
  })
  default = {
    Name = "NONPROD-PUB-SN-A"
    Environment = "NONPROD"
  }
}

variable "nonprod_pub_subnet_B_tags" {
  type = object({
    Name = string
    Environment = string
  })
  default = {
    Name = "NONPROD-PUB-SN-B"
    Environment = "value"
  }
}
variable "prod_eip_tags" {
  type = object({
    Name = string
    Environment = string
  })
  default = {
    Name = "PROD-EIP-NAT"
    Environment = "PROD"
  }
}

variable "nonprod_eip_tags" {
  type = object({
    Name = string
    Environment = string
  })
  default = {
    Name = "NONPROD-EIP-NAT"
    Environment = "NONPROD"
  }
}

variable "prod_nat_tags" {
  type = object({
    Name = string
    Environment = string
  })
  default = {
    Name = "PROD-NAT"
    Environment = "PROD"
  }
}

variable "nonprod_nat_tags" {
  type = object({
    Name = string
    Environment = string
  })
  default = {
    Name = "NONPROD-NAT"
    Environment = "NONPROD"
  }
}

variable "prod_prv_rt_tags" {
  type = object({
    Name = string
    Environment = string
  })
  default = {
    Name = "PROD-PRV-RT"
    Environment = "PROD"
  }
}

variable "prod_pub_rt_tags" {
  type = object({
    Name = string
    Environment = string
  })
  default = {
    Name = "PROD-PUB-RT"
    Environment = "PROD"
  }
}

variable "nonprod_prv_rt_tags" {
  type = object({
    Name = string
    Environment = string
  })
  default = {
    Name = "NONPROD-PRV-RT"
    Environment = "NONPROD"
  }
}

variable "nonprod_pub_rt_tags" {
  type = object({
    Name = string
    Environment = string
  })
  default = {
    Name = "NONPROD-PUB-RT"
    Environment = "NONPROD"
  }
}

variable "prod_igw_tags" {
  type = object({
    Name = string
    Environment = string
  })
  default = {
    Name = "PROD-IGW"
    Environment = "PROD"
  }
}

variable "nonprod_igw_tags" {
  type = object({
    Name = string
    Environment = string
  })
  default = {
    Name = "NONPROD-IGW"
    Environment = "NONPROD"
  }
}

variable "prod_df_sg_tags" {
  type = object({
    Name = string
    Environment = string
    Access = string
  })
  default = {
    Name = "PROD-DEFAULT-SG"
    Environment = "PROD"
    Access = "HTTPS-HTTP-SSH"
  }
}

variable "nonprod_df_sg_tags" {
  type = object({
    Name = string
    Environment = string
    Access = string
  })
  default = {
    Name = "NONPROD-DEFAULT-SG"
    Environment = "NONPROD"
    Access = "HTTPS-HTTP-SSH"
  }
}

variable "environments" {
  type    = map
  default = {
    "prod" = "PROD"
    "nonprod" = "NONPROD"
    "qa" = "QA"
    "uat" = "UAT"
    "feature" = "FEATURE"
  }
}

# /22 mask allows for 1022 usable hosts per subnet
variable "cidr_blocks" {
    type = map
    default = {
        "prod-vpc" = "10.10.0.0/16"
        "prod-prv-cidr-A" = "10.10.0.0/22"
        "prod-prv-cidr-B" = "10.10.4.0/22"
        "prod-pub-cidr-A" = "10.10.8.0/22"
        "prod-pub-cidr-B" = "10.10.12.0/22"
        "all-ipv4" = "0.0.0.0/0"
        "all-ipv6" = "::/0"
        "nonprod-vpc" = "10.20.0.0/16"
        "nonprod-prv-cidr-A" = "10.20.0.0/22"
        "nonprod-prv-cidr-B" = "10.20.4.0/22"
        "nonprod-pub-cidr-A" = "10.20.8.0/22"
        "nonprod-pub-cidr-B" = "10.20.12.0/22"
    }
}

variable "AZ-names" {
    type = map
    default = {
        "prv-az-A" = "us-east-1a"
        "prv-az-B" = "us-east-1b"
        "pub-az-A" = "us-east-1a"
        "pub-az-B" = "us-east-1b"
    }
}