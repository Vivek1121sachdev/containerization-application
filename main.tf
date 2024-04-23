#----------------#
# Provider Block #
#----------------#

provider "aws" {
  region = var.region
}

#-----#
# VPC #
#-----#

module "vpc" {
  source               = ".\\modules\\vpc"
  tag-prefix           = "CA"
  vpc_ip               = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
  availability_zone    = ["us-east-1a","us-east-1b"]
}

#----------#
# Gateways #
# ---------#

module "GW" {
  source           = ".\\modules\\GW"
  tag-prefix       = "CA"
  vpc_id           = module.vpc.vpc_id
  public_subnet_id = module.vpc.public_subnet_id[0]
}

#--------------#
# Route Tables #
#--------------#

module "RT" {
  source            = ".\\modules\\RT"
  tag-prefix        = "CA"
  cidr_block        = "0.0.0.0/0"
  vpc_id            = module.vpc.vpc_id
  ig_id             = module.GW.ig_id
  nat_gw_id         = module.GW.nat_gw_id
  public_subnet_id  = module.vpc.public_subnet_id
  private_subnet_id = module.vpc.private_subnet_id
}

#---------------------------#
# Application Load Balancer #
#---------------------------#

module "alb" {
  source   = ".\\modules\\alb"
  lb_name = "CA-Load-Balancer"
  lb_type = "application"
  tg_name = "CA-Target-Group"
  target_type = "ip"
  action_type = "forward"
  vpc_id = module.vpc.vpc_id
  app_port = 3000
  public_subnet_id = module.vpc.public_subnet_id
}

#-----#
# ECR #
#-----#

module "ecr" {
  source = ".\\modules\\ecr"
  repository_name = "container-application"
}

#-----#
# ECS #
#-----#

module "ecs" {
  source = ".\\modules\\ecs"
  app_port = 3000
  lb_sg = [module.alb.lb_sg_id]
  vpc_id = module.vpc.vpc_id
  cluster_name = "cluster"
  ecr_image = "${module.ecr.repository_url}:${data.aws_ecr_image.image.image_tags[0]}"
  private_subnet = module.vpc.private_subnet_id
  tg_arn = module.alb.tg_arn
}

#----------------------#
# CloudWatch Log Group #
#----------------------#

module "cloudwatch" {
  source = ".\\modules\\cloudwatch"
  log_group_name = "/ecs/CA-App"
}

#-----#
# RDS #
#-----#

module "rds" {
  source = ".\\modules\\rds"
  private_subnets = module.vpc.private_subnet_id
  db_subnet_group_name = "ca-db-subnet-group"
  db-identifier-name = "ca-rds-database"
  ecs_sg = module.ecs.ecs_sg
  vpc_id =  module.vpc.vpc_id
  instance_class = "db.t3.micro"
  storage_allocaiton = 10
  engine_type = "postgres"
  engine_version = "16.2"
  username = "vivek"
}