##################
# Security Group #
##################

resource "aws_security_group" "db_sg" {
  name_prefix = "${var.tag_prefix}"
  vpc_id = var.vpc_id
  ingress {
    from_port   = var.app_port
    to_port     = var.db_port
    protocol    = var.db_sg_protocol
    security_groups = [var.ecs_sg]
  }
}

#########################
# Database Subnet Group #
#########################

resource "aws_db_subnet_group" "db_subnet_grp" {
  name       = var.db_subnet_group_name
  subnet_ids = var.private_subnets
}

#####################
# Database Instance #
#####################

resource "aws_db_instance" "rds" {
  identifier             = var.db-identifier-name
  instance_class         = var.instance_class
  allocated_storage      = var.storage_allocaiton
  engine                 = var.engine_type
  engine_version         = var.engine_version
  username               = element(local.username,0)
  password               = element(local.password,0)
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_grp.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  publicly_accessible    = var.publicly_accessible
  skip_final_snapshot    = var.skip_final_snapshot
}