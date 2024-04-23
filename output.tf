output "public_subnet_id" {
  value = module.vpc.public_subnet_id
}

output "private_subnet_id" {
  value = module.vpc.private_subnet_id
}
# output "key-pair" {
#   value     = module.ec2.private_key_pem
#   sensitive = true
# }