provider "aws" {
  region = var.region
}

resource "aws_vpc" "prod_vpc" {
  cidr_block = var.cidr_blocks["vpc"]
  tags = {
    "Name" = "DEVOPS-VPC-PROD"
  }
}
# Internet Gateway for Public Subnet
resource "aws_internet_gateway" "prod_igw" {
  vpc_id = aws_vpc.prod_vpc.id
  tags = {
    Name        = "DEVOPS-IGW"
    Environment = "PROD"
  }
}

# Elastic-IP (eip) for NAT
resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.prod_igw]
}
resource "aws_subnet" "prv-subnetA" {
    vpc_id = aws_vpc.prod_vpc.id
    cidr_block = var.cidr_blocks["priv-subnetA"]
    availability_zone = var.AZ-names["privateA"]
    map_public_ip_on_launch = false
    tags = {
      "Name" = var.subnet_tags["privateA"]
    }
    depends_on = [aws_vpc.prod_vpc]
}  

resource "aws_subnet" "pub-subnetA" {
    vpc_id = aws_vpc.prod_vpc.id
    cidr_block = var.cidr_blocks["pub-subnetA"]
    availability_zone = var.AZ-names["publicA"]
    map_public_ip_on_launch = true
    tags = {
      "Name" = var.subnet_tags["publicA"]
    }
    depends_on = [aws_vpc.prod_vpc]
}  

# NAT
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.pub-subnetA.id

  tags = {
    Name        = "DEVOPS-NAT"
    Environment = "PROD"
  }
}

# Routing tables to route traffic for Private Subnet
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.prod_vpc.id

  tags = {
    Name        = "DEVOPS-private-route-table"
    Environment = "PROD"
  }
}

# Routing tables to route traffic for Public Subnet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.prod_vpc.id

  tags = {
    Name        = "DEVOPS-public-route-table"
    Environment = "PROD"
  }
}

# Route for Internet Gateway
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.prod_igw.id
}

# Route for NAT
resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

# Route table associations for both Public & Private Subnets
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.pub-subnetA.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.prv-subnetA.id
  route_table_id = aws_route_table.private.id
}

# Default Security Group of VPC
resource "aws_security_group" "default" {
  name        = "DEVOPS-default-sg"
  description = "Default SG to alllow traffic from the VPC"
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

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Environment = "PROD"
  }
}
