output "vpc_id" {
  description = "VPC Id"
  value = aws_vpc.vpc.id
}

output "public_subnet_id" {
  description = "Public Subnet Id"
  value = aws_subnet.public-subnet[*].id
}

output "private_subnet_id" {
  description = "Private Subent Id"
  value = aws_subnet.private-subnet[*].id
}