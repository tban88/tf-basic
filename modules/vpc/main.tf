# Define provided: AWS
provider "aws" {
  region = var.region
}

######################## PROD ########################

# Create new VPC - PROD
resource "aws_vpc" "prod_vpc" {
  cidr_block = var.cidr_blocks["prod-vpc"]
  enable_dns_hostnames = true
  tags = {
    "Name" = "PROD-VPC"
  }
}

# Internet Gateway for Public Subnet - PROD
resource "aws_internet_gateway" "prod_igw" {
  vpc_id = aws_vpc.prod_vpc.id
  tags = {
    Name        = "PROD-IGW"
    Environment = var.environments["prod"]
  }
}

# Create PRIVATE subnet A - PROD
resource "aws_subnet" "prod_prv_subnet_A" {
    vpc_id = aws_vpc.prod_vpc.id
    cidr_block = var.cidr_blocks["prod-prv-cidr-A"]
    availability_zone = var.AZ-names["prv-az-A"]
    map_public_ip_on_launch = false
    tags = {
      "Name" = var.subnet_tags["prod-prv-tag-A"]
    }
    depends_on = [aws_vpc.prod_vpc]
}  

# Create PRIVATE subnet B - PROD
resource "aws_subnet" "prod_prv_subnet_B" {
    vpc_id = aws_vpc.prod_vpc.id
    cidr_block = var.cidr_blocks["prod-prv-cidr-B"]
    availability_zone = var.AZ-names["prv-az-B"]
    map_public_ip_on_launch = false
    tags = {
      "Name" = var.subnet_tags["prod-prv-tag-B"]
    }
    depends_on = [aws_vpc.prod_vpc]
}  

# Create PUBLIC subnet A - PROD
resource "aws_subnet" "prod_pub_subnet_A" {
    vpc_id = aws_vpc.prod_vpc.id
    cidr_block = var.cidr_blocks["prod-pub-cidr-A"]
    availability_zone = var.AZ-names["pub-az-A"]
    map_public_ip_on_launch = true
    tags = {
      "Name" = var.subnet_tags["prod-pub-tag-A"]
    }
    depends_on = [aws_vpc.prod_vpc]
}  

# Create PUBLIC subnet B - PROD
resource "aws_subnet" "prod_pub_subnet_B" {
    vpc_id = aws_vpc.prod_vpc.id
    cidr_block = var.cidr_blocks["prod-pub-cidr-B"]
    availability_zone = var.AZ-names["pub-az-B"]
    map_public_ip_on_launch = true
    tags = {
      "Name" = var.subnet_tags["prod-pub-tag-B"]
    }
    depends_on = [aws_vpc.prod_vpc]
} 

# Elastic-IP (eip) for NAT - PROD
resource "aws_eip" "prod_nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.prod_igw]
  tags = {
    "Name" = "PROD-EIP-NAT"
  }
}

# Create NAT - PROD
resource "aws_nat_gateway" "prod_nat" {
  allocation_id = aws_eip.prod_nat_eip.id
  subnet_id     = aws_subnet.prod_pub_subnet_A.id

  tags = {
    Name        = "PROD-NAT"
    Environment = var.environments["prod"]
  }
}

# Create routing tables to route traffic for Private Subnet - PROD
resource "aws_route_table" "prod_prv_rt" {
  vpc_id = aws_vpc.prod_vpc.id

  tags = {
    Name        = "PROD-PRV-RT"
    Environment = var.environments["prod"]
  }
}

# Create routing tables to route traffic for Public Subnet - PROD
resource "aws_route_table" "prod_pub_rt" {
  vpc_id = aws_vpc.prod_vpc.id

  tags = {
    Name        = "PROD-PUB-RT"
    Environment = var.environments["prod"]
  }
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
  name        = "PROD-SSH-HTTPS-HTTP"
  description = "Allows basic inbound connectivity via HTTP(s) and SSH"
  vpc_id      = aws_vpc.prod_vpc.id
  depends_on = [
    aws_vpc.prod_vpc
  ]

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
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Environment = var.environments["nonprod"]
  }
}

######################## NON PROD ########################

# Create new VPC - NONPROD
resource "aws_vpc" "nonprod_vpc" {
  cidr_block = var.cidr_blocks["nonprod-vpc"]
  enable_dns_hostnames = true
  tags = {
    "Name" = "NONPROD-VPC"
  }
}

# Internet Gateway for Public Subnet - NONPROD
resource "aws_internet_gateway" "nonprod_igw" {
  vpc_id = aws_vpc.nonprod_vpc.id
  tags = {
    Name        = "NONPROD-IGW"
    Environment = var.environments["nonprod"]
  }
}

# Create PRIVATE subnet A - NONPROD
resource "aws_subnet" "nonprod_prv_subnet_A" {
    vpc_id = aws_vpc.nonprod_vpc.id
    cidr_block = var.cidr_blocks["nonprod-prv-cidr-A"]
    availability_zone = var.AZ-names["prv-az-A"]
    map_public_ip_on_launch = false
    tags = {
      "Name" = var.subnet_tags["nonprod-prv-tag-A"]
    }
    depends_on = [aws_vpc.nonprod_vpc]
}  

# Create PRIVATE subnet B - NONPROD
resource "aws_subnet" "nonprod_prv_subnet_B" {
    vpc_id = aws_vpc.nonprod_vpc.id
    cidr_block = var.cidr_blocks["nonprod-prv-cidr-B"]
    availability_zone = var.AZ-names["prv-az-B"]
    map_public_ip_on_launch = false
    tags = {
      "Name" = var.subnet_tags["nonprod-prv-tag-B"]
    }
    depends_on = [aws_vpc.nonprod_vpc]
}  

# Create PUBLIC subnet A - NONPROD
resource "aws_subnet" "nonprod_pub_subnet_A" {
    vpc_id = aws_vpc.nonprod_vpc.id
    cidr_block = var.cidr_blocks["nonprod-pub-cidr-A"]
    availability_zone = var.AZ-names["pub-az-A"]
    map_public_ip_on_launch = true
    tags = {
      "Name" = var.subnet_tags["nonprod-pub-tag-A"]
    }
    depends_on = [aws_vpc.nonprod_vpc]
}  

# Create PUBLIC subnet B - NONPROD
resource "aws_subnet" "nonprod_pub_subnet_B" {
    vpc_id = aws_vpc.nonprod_vpc.id
    cidr_block = var.cidr_blocks["nonprod-pub-cidr-B"]
    availability_zone = var.AZ-names["pub-az-B"]
    map_public_ip_on_launch = true
    tags = {
      "Name" = var.subnet_tags["nonprod-pub-tag-B"]
    }
    depends_on = [aws_vpc.nonprod_vpc]
} 

# Elastic-IP (eip) for NAT - NONPROD
resource "aws_eip" "nonprod_nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.nonprod_igw]
  tags = {
    "Name" = "NONPROD-EIP-NAT"
  }
}

# Create NAT - NONPROD
resource "aws_nat_gateway" "nonprod_nat" {
  allocation_id = aws_eip.nonprod_nat_eip.id
  subnet_id     = aws_subnet.nonprod_pub_subnet_A.id

  tags = {
    Name        = "NONPROD-NAT"
    Environment = var.environments["nonprod"]
  }
}

# Create routing tables to route traffic for Private Subnet - NONPROD
resource "aws_route_table" "nonprod_prv_rt" {
  vpc_id = aws_vpc.nonprod_vpc.id

  tags = {
    Name        = "NONPROD-PRV-RT"
    Environment = var.environments["nonprod"]
  }
}

# Create routing tables to route traffic for Public Subnet - NONPROD
resource "aws_route_table" "nonprod_pub_rt" {
  vpc_id = aws_vpc.nonprod_vpc.id

  tags = {
    Name        = "NONPROD-PUB-RT"
    Environment = var.environments["nonprod"]
  }
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
  name        = "NONPROD-SSH-HTTPS-HTTP"
  description = "Allows basic inbound connectivity via HTTP(s) and SSH"
  vpc_id      = aws_vpc.nonprod_vpc.id
  depends_on = [
    aws_vpc.nonprod_vpc
  ]

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
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Environment = var.environments["nonprod"]
  }
}