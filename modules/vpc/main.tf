#############
# VPC Block #
#############

resource "aws_vpc" "vpc" {
  cidr_block       = "${var.vpc_ip}"
  instance_tenancy = "default"

  tags = {
    Name = "${var.tag-prefix}-VPC"
  }
}

##################
# Public Subnets #
##################

resource "aws_subnet" "public-subnet" {
  count = length(var.public_subnet_cidrs)

  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.public_subnet_cidrs[count.index]
  availability_zone = var.availability_zone[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.tag-prefix}-Public-${count.index + 1}"
  }
}


###################
# Private Subnets #
###################

resource "aws_subnet" "private-subnet" {
  count = length(var.private_subnet_cidrs)

  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zone[count.index]

  tags = {
    Name = "${var.tag-prefix}-Private-${count.index+1}"
  }
}
