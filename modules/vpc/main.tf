#############
# VPC Block #
#############

resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc_ip
  instance_tenancy = "default"

  tags = {
    Name = "${var.tag-prefix}-VPC"
  }
}

##################
# Public Subnets #
##################

resource "aws_subnet" "public-subnet" {
  for_each = var.public_subnet

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.tag-prefix}-Public-Subnet"
  }
}

###########################
# Private Subnets for ECR #
###########################

resource "aws_subnet" "private-subnet-ecs" {
  # count = length(var.private_subnet_cidrs)
  for_each = var.private_subnet_ecs

  vpc_id            = aws_vpc.vpc.id
  availability_zone = each.key
  cidr_block        = each.value

  tags = {
    Name = "${var.tag-prefix}-Private-Subnet-ECS"
  }
}

###########################
# Private Subnets for RDS #
###########################

resource "aws_subnet" "private-subnet-rds" {
  for_each = var.private_subnet_rds

  vpc_id            = aws_vpc.vpc.id
  availability_zone = each.key
  cidr_block        = each.value

  tags = {
    Name = "${var.tag-prefix}-Private-Subnet-RDS"
  }
}


####################
# Internet Gateway #
####################

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.tag-prefix}-IGW"
  }
}

##############
# Elastic IP #
##############

resource "aws_eip" "eip" {
  domain = "vpc"

  tags = {
    Name = "${var.tag-prefix}-EIP"
  }
}

###############
# NAT Gateway #
###############

resource "aws_nat_gateway" "nat_gw" {

  allocation_id = aws_eip.eip.id
  subnet_id     = local.first_public_subnet_id

  tags = {
    Name = "${var.tag-prefix}-NAT-GW"
  }

  depends_on = [aws_internet_gateway.igw]
}


#################################
# Route Table for Public Subnet #
#################################

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.public_cidr_block
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.tag-prefix}-Public-Route-Table"
  }
}

// Public Subnet Association //
resource "aws_route_table_association" "public_rt_association" {
  for_each      = aws_subnet.public-subnet
  
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public-rt.id

  depends_on = [ aws_subnet.public-subnet ]
}

###############################
# Private Route Table For ECS #
###############################

resource "aws_route_table" "private-rt-ecs" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.public_cidr_block
    gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "${var.tag-prefix}-Private-Route-Table-ECS"
  }
}

// Private Subnet Association //
resource "aws_route_table_association" "private_rt_association_ecs" {
  for_each      = aws_subnet.private-subnet-ecs
  
  subnet_id     = each.value.id
  route_table_id = aws_route_table.private-rt-ecs.id
}

###############################
# Private Route Table For RDS #
###############################

resource "aws_route_table" "private-rt-rds" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.tag-prefix}-Private-Route-Table-RDS"
  }
}

// Private Subnet Association //
resource "aws_route_table_association" "private_rt_association_rds" {
  for_each      = aws_subnet.private-subnet-rds

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private-rt-rds.id
}