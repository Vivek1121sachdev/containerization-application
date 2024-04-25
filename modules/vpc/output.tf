output "vpc_id" {
  description = "VPC Id"
  value       = aws_vpc.vpc.id
}

output "public_subnet_id" {
  description = "Public Subnet Id"
  value       = [for subnets in aws_subnet.public-subnet : subnets.id]
}

output "private_subnet_ecs_id" {
  description = "Private Subent Id"
  value       = [for subnets in aws_subnet.private-subnet-ecs : subnets.id]
}

output "private_subnet_rds_id" {
  description = "Private Subent Id"
  value       = [for subnets in aws_subnet.private-subnet-rds : subnets.id]
}

output "ig_id" {
  description = "Internet Gateway Id"
  value       = aws_internet_gateway.igw.id
}

output "nat_gw_id" {
  description = "NAT Gateway Id"
  value       = aws_nat_gateway.nat_gw.id
}