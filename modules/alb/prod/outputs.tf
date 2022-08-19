output "lb_arn" {
  value = aws_lb.prod_lb.arn
}

output "dns_url" {
  value = aws_lb.prod_lb.dns_name
}