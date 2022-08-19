output "lb_arn" {
  value = aws_lb.nonprod_lb.arn
}

output "dns_url" {
  value = aws_lb.nonprod_lb.dns_name
}