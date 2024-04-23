output "ig_id" {
  description = "Internet Gateway Id"
  value = aws_internet_gateway.igw.id
}

output "nat_gw_id" {
  description = "NAT Gateway Id"
  value = aws_nat_gateway.nat_gw.id
}