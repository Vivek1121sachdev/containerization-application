locals {

  first_public_subnet_id = values(aws_subnet.public-subnet)[0].id

  public_subnet_id      = data.aws_subnets.public.ids
  private_subnet_ecs_id = data.aws_subnets.private_ecs.ids
  private_subnet_rds_id = data.aws_subnets.private_rds.ids

  public_subnet_cidrs = values(var.public_subnet)

}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [aws_vpc.vpc.id]
  }
  filter {
    name   = "tag:Name"
    values = ["CA-Public-Subnet"]
  }
}

data "aws_subnets" "private_ecs" {
  filter {
    name   = "vpc-id"
    values = [aws_vpc.vpc.id]
  }
  filter {
    name   = "tag:Name"
    values = ["CA-Private-Subnet-ECS"]
  }
}

data "aws_subnets" "private_rds" {
  filter {
    name   = "vpc-id"
    values = [aws_vpc.vpc.id]
  }
  filter {
    name   = "tag:Name"
    values = ["CA-Private-Subnet-RDS"]
  }
}