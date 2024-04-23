####################
# Internet Gateway #
####################

resource "aws_internet_gateway" "igw" {
 vpc_id = var.vpc_id
 
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
  subnet_id     = var.public_subnet_id

  tags = {
    Name = "${var.tag-prefix}-NAT-GW"
  }

  depends_on = [aws_internet_gateway.igw]
}