output "subnet_id" {
  value = aws_subnet.new_pub_subnet.id
}

output "route_id" {
  value = aws_route_table.new_pub_rt.id
}