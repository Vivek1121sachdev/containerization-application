#----------------#
# Provider Block #
#----------------#

provider "aws" {
  region = var.region
}

terraform {
  # Can be removed when bug is resolved: https://github.com/hashicorp/terraform-provider-aws/issues/23110
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

#-----#
# VPC #
#-----#

module "vpc" {
  source             = ".\\modules\\vpc"
  tag-prefix         = "CA"
  vpc_ip             = "10.0.0.0/16"
  public_cidr_block  = "0.0.0.0/0"
  public_subnet      = { "us-east-1a" = "10.0.1.0/24", "us-east-1b" = "10.0.2.0/24" }
  private_subnet_ecs = { "us-east-1a" = "10.0.3.0/24", "us-east-1b" = "10.0.4.0/24" }
  private_subnet_rds = { "us-east-1a" = "10.0.5.0/24", "us-east-1b" = "10.0.6.0/24" }
}


#---------------------------#
# Application Load Balancer #
#---------------------------#

module "alb" {
  source           = ".\\modules\\alb"
  lb_name          = "CA-Load-Balancer"
  lb_type          = "application"
  tg_name          = "CA-Target-Group"
  target_type      = "ip"
  action_type      = "forward"
  vpc_id           = module.vpc.vpc_id
  app_port         = 3000
  public_subnet_id = module.vpc.public_subnet_id
}

#-----#
# ECR #
#-----#

module "ecr" {
  source          = ".\\modules\\ecr"
  repository_name = "container-application"
}

#-----#
# ECS #
#-----#

module "ecs" {
  source                      = ".\\modules\\ecs"
  ecs_sg_name                 = "CA-ECS-SG"
  sg_protocol                 = "tcp"
  app_port                    = 3000
  lb_sg                       = [module.alb.lb_sg_id]
  vpc_id                      = module.vpc.vpc_id
  cluster_name                = "cluster"
  task_defination_family_name = "CA-app-task"
  app_env                     = ["FARGATE"]
  network_mode                = "awsvpc"
  ecr_image                   = "${module.ecr.repository_url}:${data.aws_ecr_image.image.image_tags[0]}"
  private_subnet              = module.vpc.private_subnet_ecs_id
  tg_arn                      = module.alb.tg_arn
}

#----------------------#
# CloudWatch Log Group #
#----------------------#

module "cloudwatch" {
  source         = ".\\modules\\cloudwatch"
  log_group_name = "/ecs/CA-App"
}

#---------------#
# SSM Parameter #
#---------------#

resource "aws_ssm_parameter" "rds_credentials" {
  for_each = local.parameter

  name  = each.key
  value = each.value
  type  = "String"
}

#-----#
# RDS #
#-----#

module "rds" {
  source               = ".\\modules\\rds"
  credentials          = local.parameter
  private_subnets      = module.vpc.private_subnet_rds_id
  db_subnet_group_name = "ca-db-subnet-group"
  db-identifier-name   = "ca-rds-database"
  ecs_sg               = module.ecs.ecs_sg
  vpc_id               = module.vpc.vpc_id
  instance_class       = "db.t3.micro"
  storage_allocaiton   = 10
  engine_type          = "postgres"
  engine_version       = "16.2"
  username             = "vivek"
}