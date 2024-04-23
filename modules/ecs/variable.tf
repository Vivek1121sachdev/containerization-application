variable "tag_prefix" {
  type = string
  description = "tag prefix"
  default = "CA"
}

variable "region" {
  type = string
  description = "Region Name"
  default = "us-east-1"
}

variable "app_port" {
  type = number
  description = "application port"
  default = 3000
}

variable "lb_sg" {
  type = list(string)
  description = "load balancer sg id"
}

variable "tg_arn" {
  type = string
  description = "Target Group Arn"
}

variable "vpc_id" {
  type = string
  description = "vpc id"
}

variable "cluster_name" {
  type = string
  description = "cluster name"
}

variable "ecr_image" {
  type = string
  description = "ecr image"
}

variable "log_group_name" {
  type = string
  description = "cloudwatch log group name"
  default = "/ecs/CA-App"
}

variable "fargate_cpu" {
  type = number
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default = "1024"
}

variable "fargate_memory" {
  type = number  
  description = "Fargate instance memory to provision (in MiB)"
  default = "2048"
}

variable "app_count" {
  type = number
  description = "Number of docker containers to run"
  default = 1
}

variable "private_subnet" {
  type = list(string)
  description = "private subnet ids"
}

