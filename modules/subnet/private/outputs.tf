output "subnet_id" {
    value = aws_subnet.new_prv_subnet.id
}

output "route_id" {
    value = aws_route_table.new_prv_rt.id
}