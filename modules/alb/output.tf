output "lb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "tg_arn" {
  value = aws_alb_target_group.target_group.arn
}