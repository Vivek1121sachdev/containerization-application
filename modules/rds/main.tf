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

resource "aws_db_subnet_group" "db_subnet_grp" {
  name       = var.db_subnet_group_name
  subnet_ids = var.private_subnets
}

resource "aws_db_instance" "rds" {
  identifier             = var.db-identifier-name
  instance_class         = var.instance_class
  allocated_storage      = var.storage_allocaiton
  engine                 = var.engine_type
  engine_version         = var.engine_version
  username               = var.username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_grp.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  publicly_accessible    = var.publicly_accessible
  skip_final_snapshot    = var.skip_final_snapshot
}