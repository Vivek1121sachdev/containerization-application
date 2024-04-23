output "public_subnet_id" {
  description = "Public Subnet Ids"
  value = module.vpc.public_subnet_id
}

output "private_subnet_id" {
  description = "Private Subnet IDs"
  value = module.vpc.private_subnet_id
}

output "alb_dns_name" {
  description = "Load Balancer DNS Name"
  value = module.alb.lb_dns_name
}