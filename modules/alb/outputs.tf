output "jenkins_tg_arn" {
  value = aws_lb_target_group.prod_pub_jenkins_tg.arn
}

output "prod_alb_public_arn" {
  value = aws_lb.prod_pub_alb.arn
}

output "alb_dns_prod_public" {
  value = aws_lb.prod_pub_alb.dns_name
}