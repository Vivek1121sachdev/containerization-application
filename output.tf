output "public_subnet_id" {
  description = "Public Subnet Ids"
  value       = module.vpc.public_subnet_id
}

output "private_subnet_ecs_id" {
  description = "Private Subnet IDs for ECS"
  value       = module.vpc.private_subnet_ecs_id
}

output "private_subnet_rds_id" {
  description = "Private Subnet IDs for RDS"
  value       = module.vpc.private_subnet_rds_id
}

output "alb_dns_name" {
  description = "Load Balancer DNS Name"
  value       = "http://${module.alb.lb_dns_name}"
}