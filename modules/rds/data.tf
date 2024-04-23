locals {
    username = [for key,value in data.aws_ssm_parameter.rds_credentials: key]
    password = [for password in data.aws_ssm_parameter.rds_credentials: password.value]
}

data "aws_ssm_parameter" "rds_credentials" {
  for_each = var.credentials
  name = each.key
}