output "vpc_id" {
  value = aws_vpc.new_vpc.id
}

output "igw_id" {
  value = aws_internet_gateway.new_igw.id
}