output "lb_dns" {
  value = aws_lb.alb.dns_name
}

output "asg_name" {
  value = aws_autoscaling_group.asg.name
}

output "encrypt_lb_dns" {
  value = aws_lb_target_group.tg_encrypt.arn
}

output "jwt_generate_lb_dns" {
  value = aws_lb_target_group.tg_jwt_generate.arn
}

output "jwt_validate_lb_dns" {
  value = aws_lb_target_group.tg_jwt_validate.arn
}
