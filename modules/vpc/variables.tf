variable "region" {
  type    = string
  default = "us-east-1"
}

variable "prod_vpc_tags" {
  type = object({
    Name = string
    Environment = string
  })
  default = {
    Name = "value"
    Environment = "value"
  }
}

variable "nonprod_vpc_tags" {
  type = object({
    Name = string
    Environment = string
  })
  default = {
    Name = "value"
    Environment = "value"
  }
}

variable "prod_prv_subnet_A_tags" {
  type = object({
    Name = string
    Environment = string
  })
  default = {
    Name = "value"
    Environment = "value"
  }
}

variable "prod_prv_subnet_B_tags" {
  type = object({
    Name = string
    Environment = string
  })
  default = {
    Name = "value"
    Environment = "value"
  }
}

variable "prod_pub_subnet_A_tags" {
  type = object({
    Name = string
    Environment = string
  })
  default = {
    Name = "value"
    Environment = "value"
  }
}

variable "prod_pub_subnet_B_tags" {
  type = object({
    Name = string
    Environment = string
  })
  default = {
    Name = "value"
    Environment = "value"
  }
}

variable "nonprod_prv_subnet_A_tags" {
  type = object({
    Name = string
    Environment = string
  })
  default = {
    Name = "value"
    Environment = "value"
  }
}

variable "nonprod_prv_subnet_B_tags" {
  type = object({
    Name = string
    Environment = string
  })
  default = {
    Name = "value"
    Environment = "value"
  }
}

variable "nonprod_pub_subnet_A_tags" {
  type = object({
    Name = string
    Environment = string
  })
  default = {
    Name = "value"
    Environment = "value"
  }
}

variable "nonprod_pub_subnet_B_tags" {
  type = object({
    Name = string
    Environment = string
  })
  default = {
    Name = "value"
    Environment = "value"
  }
}
variable "prod_eip_tags" {
  type = object({
    Name = string
    Environment = string
  })
  default = {
    Name = "value"
    Environment = "value"
  }
}

variable "nonprod_eip_tags" {
  type = object({
    Name = string
    Environment = string
  })
  default = {
    Name = "value"
    Environment = "value"
  }
}

variable "prod_nat_tags" {
  type = object({
    Name = string
    Environment = string
  })
  default = {
    Name = "value"
    Environment = "value"
  }
}

variable "nonprod_nat_tags" {
  type = object({
    Name = string
    Environment = string
  })
  default = {
    Name = "value"
    Environment = "value"
  }
}

variable "prod_prv_rt_tags" {
  type = object({
    Name = string
    Environment = string
  })
  default = {
    Name = "value"
    Environment = "value"
  }
}

variable "prod_pub_rt_tags" {
  type = object({
    Name = string
    Environment = string
  })
  default = {
    Name = "value"
    Environment = "value"
  }
}

variable "nonprod_prv_rt_tags" {
  type = object({
    Name = string
    Environment = string
  })
  default = {
    Name = "value"
    Environment = "value"
  }
}

variable "nonprod_pub_rt_tags" {
  type = object({
    Name = string
    Environment = string
  })
  default = {
    Name = "value"
    Environment = "value"
  }
}

variable "prod_igw_tags" {
  type = object({
    Name = string
    Environment = string
  })
  default = {
    Name = "value"
    Environment = "value"
  }
}

variable "nonprod_igw_tags" {
  type = object({
    Name = string
    Environment = string
  })
  default = {
    Name = "value"
    Environment = "value"
  }
}

variable "prod_df_sg_tags" {
  type = object({
    Name = string
    Environment = string
    Access = string
  })
  default = {
    Name = "value"
    Environment = "value"
    Access = "value"
  }
}

variable "nonprod_df_sg_tags" {
  type = object({
    Name = string
    Environment = string
    Access = string
  })
  default = {
    Name = "value"
    Environment = "value"
    Access = "value"
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

variable "subnet_tags" {
    type = map
    default = {
        "prod-prv-tag-A" = "PROD-PRIV-A"
        "prod-prv-tag-B" = "PROD-PRIV-B"
        "prod-pub-tag-A" = "PROD-PUB-A"
        "prod-pub-tag-B" = "PROD-PUB-B" 
        "nonprod-prv-tag-A" = "NONPROD-PRIV-A"
        "nonprod-prv-tag-B" = "NONPROD-PRIV-B"
        "nonprod-pub-tag-A" = "NONPROD-PUB-A"
        "nonprod-pub-tag-B" = "NONPROD-PUB-B" 
    }

}