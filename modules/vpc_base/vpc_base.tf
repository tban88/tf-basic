######################## TERRAFORM CONFIG ########################

terraform {
  required_version = ">=1.2"
}

######################## PROVIDERS ########################

# Define provided: AWS
provider "aws" {
  region = var.region
}

######################## DATA: VPC ########################

### PROD ###

data "aws_vpc" "prod_vpc_data" {
  id = aws_vpc.prod_vpc.id
}

### NONPROD ###

data "aws_vpc" "nonprod_vpc_data" {
  id = aws_vpc.nonprod_vpc.id
}

######################## LOCALS ########################

locals {
  ingress_rules = [{
    port = 443
    description = "HTTPS Access"
    protocol = "tcp"
  },
  {
    port = 8080
    description = "Jenkins Access"
    protocol = "tcp"
  },
  {
    port = 22
    description = "SSH Access"
    protocol = "tcp"
  },
  {
    port = 80
    description = "HTTP Access"
    protocol = "tcp"
  },
  {
    port = 943
    description = "VPN Access"
    protocol = "tcp"
  }]
}

######################## DATA: SUBNETS ########################

### PROD ###

data "aws_subnet" "prod_prv_subnet_A_data" {
  id = aws_subnet.prod_prv_subnet_A.id
}

data "aws_subnet" "prod_prv_subnet_B_data" {
  id = aws_subnet.prod_prv_subnet_B.id
}

data "aws_subnet" "prod_pub_subnet_A_data" {
  id = aws_subnet.prod_pub_subnet_A.id
}

data "aws_subnet" "prod_pub_subnet_B_data" {
  id = aws_subnet.prod_pub_subnet_B.id
}

### NONPROD ###

data "aws_subnet" "nonprod_prv_subnet_A_data" {
  id = aws_subnet.nonprod_prv_subnet_A.id
}

data "aws_subnet" "nonprod_prv_subnet_B_data" {
  id = aws_subnet.nonprod_prv_subnet_B.id
}

data "aws_subnet" "nonprod_pub_subnet_A_data" {
  id = aws_subnet.nonprod_pub_subnet_A.id
}

data "aws_subnet" "nonprod_pub_subnet_B_data" {
  id = aws_subnet.nonprod_pub_subnet_B.id
}

######################## DATA: SECURITY GROUPS ########################

### PROD ###

data "aws_security_group" "prod_df_sg_data" {
  id = aws_security_group.prod_default_sg.id
}

### NONPROD ###

data "aws_security_group" "nonprod_df_sg_data" {
  id = aws_security_group.nonprod_default_sg.id
}

######################## RESOURCES: PROD ########################

# Create new VPC - PROD
resource "aws_vpc" "prod_vpc" {
  cidr_block = var.cidr_blocks["prod-vpc"]
  enable_dns_hostnames = true
  tags = var.prod_vpc_tags
}

# Internet Gateway for Public Subnet - PROD
resource "aws_internet_gateway" "prod_igw" {
  vpc_id = aws_vpc.prod_vpc.id
  tags = var.prod_igw_tags
}

# Create PRIVATE subnet A - PROD
resource "aws_subnet" "prod_prv_subnet_A" {
    vpc_id = aws_vpc.prod_vpc.id
    cidr_block = var.cidr_blocks["prod-prv-cidr-A"]
    availability_zone = var.AZ-names["prv-az-A"]
    map_public_ip_on_launch = false
    tags = var.prod_prv_subnet_A_tags
}  

# Create PRIVATE subnet B - PROD
resource "aws_subnet" "prod_prv_subnet_B" {
    vpc_id = aws_vpc.prod_vpc.id
    cidr_block = var.cidr_blocks["prod-prv-cidr-B"]
    availability_zone = var.AZ-names["prv-az-B"]
    map_public_ip_on_launch = false
    tags = var.prod_prv_subnet_B_tags
}  

# Create PUBLIC subnet A - PROD
resource "aws_subnet" "prod_pub_subnet_A" {
    vpc_id = aws_vpc.prod_vpc.id
    cidr_block = var.cidr_blocks["prod-pub-cidr-A"]
    availability_zone = var.AZ-names["pub-az-A"]
    map_public_ip_on_launch = true
    tags = var.prod_pub_subnet_A_tags
}  

# Create PUBLIC subnet B - PROD
resource "aws_subnet" "prod_pub_subnet_B" {
    vpc_id = aws_vpc.prod_vpc.id
    cidr_block = var.cidr_blocks["prod-pub-cidr-B"]
    availability_zone = var.AZ-names["pub-az-B"]
    map_public_ip_on_launch = true
    tags = var.prod_pub_subnet_B_tags
} 

# Elastic-IP (eip) for NAT - PROD
resource "aws_eip" "prod_nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.prod_igw]
  tags = var.prod_eip_tags
}

# Create NAT - PROD
resource "aws_nat_gateway" "prod_nat" {
  allocation_id = aws_eip.prod_nat_eip.id
  subnet_id     = aws_subnet.prod_pub_subnet_A.id
  tags = var.prod_nat_tags
}

# Create routing tables to route traffic for Private Subnet - PROD
resource "aws_route_table" "prod_prv_rt" {
  vpc_id = aws_vpc.prod_vpc.id
  tags = var.prod_prv_rt_tags
}

# Create routing tables to route traffic for Public Subnet - PROD
resource "aws_route_table" "prod_pub_rt" {
  vpc_id = aws_vpc.prod_vpc.id
  tags = var.prod_pub_rt_tags
}

# Create route for Internet Gateway - PROD
resource "aws_route" "prod_pub_igw_rt" {
  route_table_id         = aws_route_table.prod_pub_rt.id
  destination_cidr_block = var.cidr_blocks["all-ipv4"]
  gateway_id             = aws_internet_gateway.prod_igw.id
}

# Create route for NAT - PROD
resource "aws_route" "prod_prv_nat_gateway" {
  route_table_id         = aws_route_table.prod_prv_rt.id
  destination_cidr_block = var.cidr_blocks["all-ipv4"]
  nat_gateway_id         = aws_nat_gateway.prod_nat.id
}

# Route table associations for both Public & Private Subnets - PROD

# PUB-RT association with PUB-A
resource "aws_route_table_association" "prod_pub_rt_asoc_A" {
  subnet_id      = aws_subnet.prod_pub_subnet_A.id
  route_table_id = aws_route_table.prod_pub_rt.id
}

# PUB-RT association with PUB-B
resource "aws_route_table_association" "prod_pub_rt_asoc_B" {
  subnet_id      = aws_subnet.prod_pub_subnet_B.id
  route_table_id = aws_route_table.prod_pub_rt.id
}

# PRV-RT association with PRV-A
resource "aws_route_table_association" "prod_prv_rt_asoc_A" {
  subnet_id      = aws_subnet.prod_prv_subnet_A.id
  route_table_id = aws_route_table.prod_prv_rt.id
}

# PRV-RT association with PRV-B
resource "aws_route_table_association" "prod_prv_rt_asoc_B" {
  subnet_id      = aws_subnet.prod_prv_subnet_B.id
  route_table_id = aws_route_table.prod_prv_rt.id
}

# Default Security Group of VPC
resource "aws_security_group" "prod_default_sg" {
  name = "PROD-DEFAULT-SG"
  description = "Allows basic inbound connectivity via HTTP(s) and SSH"
  vpc_id      = aws_vpc.prod_vpc.id
  depends_on = [
    aws_vpc.prod_vpc
  ]

  dynamic "ingress" {
    for_each = local.ingress_rules
    iterator = rule 

    content {
      description = rule.value.description
      from_port = rule.value.port
      to_port = rule.value.port
      protocol = rule.value.protocol
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  /*
  ingress {
    description = "SSH access"
    from_port = "22"
    to_port   = "22"
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
      description = "HTTP access"
      from_port = "80"
      to_port   = "80"
      protocol  = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ingress {
      description = "HTTPS access"
      from_port = "443"
      to_port   = "443"
      protocol  = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      description = "JENKINS access"
      from_port = "8080"
      to_port   = "8080"
      protocol  = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    */
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = var.prod_df_sg_tags
}

######################## RESOURCES: NONPROD ########################

# Create new VPC - NONPROD
resource "aws_vpc" "nonprod_vpc" {
  cidr_block = var.cidr_blocks["nonprod-vpc"]
  enable_dns_hostnames = true
  tags = var.nonprod_vpc_tags
}

# Internet Gateway for Public Subnet - NONPROD
resource "aws_internet_gateway" "nonprod_igw" {
  vpc_id = aws_vpc.nonprod_vpc.id
  tags = var.nonprod_igw_tags
}

# Create PRIVATE subnet A - NONPROD
resource "aws_subnet" "nonprod_prv_subnet_A" {
    vpc_id = aws_vpc.nonprod_vpc.id
    cidr_block = var.cidr_blocks["nonprod-prv-cidr-A"]
    availability_zone = var.AZ-names["prv-az-A"]
    map_public_ip_on_launch = false
    tags = var.nonprod_prv_subnet_A_tags
}  

# Create PRIVATE subnet B - NONPROD
resource "aws_subnet" "nonprod_prv_subnet_B" {
    vpc_id = aws_vpc.nonprod_vpc.id
    cidr_block = var.cidr_blocks["nonprod-prv-cidr-B"]
    availability_zone = var.AZ-names["prv-az-B"]
    map_public_ip_on_launch = false
    tags = var.nonprod_prv_subnet_B_tags
}  

# Create PUBLIC subnet A - NONPROD
resource "aws_subnet" "nonprod_pub_subnet_A" {
    vpc_id = aws_vpc.nonprod_vpc.id
    cidr_block = var.cidr_blocks["nonprod-pub-cidr-A"]
    availability_zone = var.AZ-names["pub-az-A"]
    map_public_ip_on_launch = true
    tags = var.nonprod_pub_subnet_A_tags
}  

# Create PUBLIC subnet B - NONPROD
resource "aws_subnet" "nonprod_pub_subnet_B" {
    vpc_id = aws_vpc.nonprod_vpc.id
    cidr_block = var.cidr_blocks["nonprod-pub-cidr-B"]
    availability_zone = var.AZ-names["pub-az-B"]
    map_public_ip_on_launch = true
    tags = var.nonprod_pub_subnet_B_tags
} 

# Elastic-IP (eip) for NAT - NONPROD
resource "aws_eip" "nonprod_nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.nonprod_igw]
  tags = var.nonprod_eip_tags
}

# Create NAT - NONPROD
resource "aws_nat_gateway" "nonprod_nat" {
  allocation_id = aws_eip.nonprod_nat_eip.id
  subnet_id     = aws_subnet.nonprod_pub_subnet_A.id
  tags = var.nonprod_nat_tags
}

# Create routing tables to route traffic for Private Subnet - NONPROD
resource "aws_route_table" "nonprod_prv_rt" {
  vpc_id = aws_vpc.nonprod_vpc.id
  tags = var.nonprod_prv_rt_tags
}

# Create routing tables to route traffic for Public Subnet - NONPROD
resource "aws_route_table" "nonprod_pub_rt" {
  vpc_id = aws_vpc.nonprod_vpc.id
  tags = var.nonprod_pub_rt_tags
}

# Create route for Internet Gateway - NONPROD
resource "aws_route" "nonprod_pub_igw_rt" {
  route_table_id         = aws_route_table.nonprod_pub_rt.id
  destination_cidr_block = var.cidr_blocks["all-ipv4"]
  gateway_id             = aws_internet_gateway.nonprod_igw.id
}

# Create route for NAT - NONPROD
resource "aws_route" "nonprod_prv_nat_gateway" {
  route_table_id         = aws_route_table.nonprod_prv_rt.id
  destination_cidr_block = var.cidr_blocks["all-ipv4"]
  nat_gateway_id         = aws_nat_gateway.nonprod_nat.id
}

# Route table associations for both Public & Private Subnets - NONPROD

# PUB-RT association with PUB-A
resource "aws_route_table_association" "nonprod_pub_rt_asoc_A" {
  subnet_id      = aws_subnet.nonprod_pub_subnet_A.id
  route_table_id = aws_route_table.nonprod_pub_rt.id
}

# PUB-RT association with PUB-B
resource "aws_route_table_association" "nonprod_pub_rt_asoc_B" {
  subnet_id      = aws_subnet.nonprod_pub_subnet_B.id
  route_table_id = aws_route_table.nonprod_pub_rt.id
}

# PRV-RT association with PRV-A
resource "aws_route_table_association" "nonprod_prv_rt_asoc_A" {
  subnet_id      = aws_subnet.nonprod_prv_subnet_A.id
  route_table_id = aws_route_table.nonprod_prv_rt.id
}

# PRV-RT association with PRV-B
resource "aws_route_table_association" "nonprod_prv_rt_asoc_B" {
  subnet_id      = aws_subnet.nonprod_prv_subnet_B.id
  route_table_id = aws_route_table.nonprod_prv_rt.id
}

# Default Security Group of VPC
resource "aws_security_group" "nonprod_default_sg" {
  name = "NONPROD-DEFAULT-SG"
  description = "Allows basic inbound connectivity via HTTP(s) and SSH"
  vpc_id      = aws_vpc.nonprod_vpc.id
  depends_on = [
    aws_vpc.nonprod_vpc
  ]

    dynamic "ingress" {
    for_each = local.ingress_rules
    iterator = rule 

    content {
      description = rule.value.description
      from_port = rule.value.port
      to_port = rule.value.port
      protocol = rule.value.protocol
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  /*
  ingress {
    description = "SSH access"
    from_port = "22"
    to_port   = "22"
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
      description = "HTTP access"
      from_port = "80"
      to_port   = "80"
      protocol  = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ingress {
      description = "HTTPS access"
      from_port = "443"
      to_port   = "443"
      protocol  = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

  ingress {
      description = "JENKINS access"
      from_port = "8080"
      to_port   = "8080"
      protocol  = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    */
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = var.nonprod_df_sg_tags
}