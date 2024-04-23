variable "tag_prefix" {
  type = string
  description = "Tag Prefix"
  default = "ca"
}

variable "db_subnet_group_name" {
  type = string
  description = "Database subnet group name"
}

variable "db-identifier-name" {
  type = string
  description = "database identifier name"
}

variable "app_port" {
  type = number
  description = "container applicaiton port number"
  default = 3000
}

variable "db_port" {
  type = number
  description = "RDS database port number"
  default = 5432
}

variable "db_sg_protocol" {
  type = string
  description = "protocol type of database security group"
  default = "tcp"
}

variable "db_password" {
  type = string
  description = "database password"
  default = "database123"
  sensitive = true
}

variable "private_subnets" {
  type = list(string)
  description = "private subnets"
}

variable "instance_class" {
  type = string
  description = "Database intance class"
}

variable "storage_allocaiton" {
  type = number
  description = "Space Allocation for Instance"
}

variable "engine_type" {
  type = string
  description = "Database Engine Type"
}

variable "engine_version" {
  type = string
  description = "Enginer Version Number"
}

variable "username" {
  type = string
  description = "Database Username"
  default = "admin"
}

variable "publicly_accessible" {
  type = bool
  description = "db should be not publically accessible"
  default = false
}

variable "skip_final_snapshot" {
  type = bool
  description = "skip final snapshot when destroying"
  default = true
}

variable "ecs_sg" {
  type = string
  description = "Security Group of ECS"
}

variable "vpc_id" {
  type = string
  description = "vpc id"
}

variable "credentials" {
  type = map
  description = "RDS credentials from ssm parameter store"
}