output "lb_sg_id" {
  description = "Load Balancer Security Group id"
  value = aws_security_group.alb_sg.id
}

output "tg_arn" {
  description = "Target Group ARN"
  value = aws_alb_target_group.target_group.arn
}

output "lb_dns_name"{
  description = "Load Balancer DNS Name"
  value = aws_alb.alb.dns_name
}