output "ecs_sg" {
  description = "ECS security group id"
  value = aws_security_group.ecs_sg.id
}