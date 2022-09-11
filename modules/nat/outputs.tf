output "eip_id" {
  value = aws_eip.new_eip.id
}

output "nat_id" {
  value = aws_nat_gateway.new_nat.id
}