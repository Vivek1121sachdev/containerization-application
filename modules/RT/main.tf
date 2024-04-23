#################################
# Route Table for Public Subnet #
#################################

resource "aws_route_table" "public-rt" {
    vpc_id = var.vpc_id

    route {
        cidr_block = var.cidr_block
        gateway_id = var.ig_id
    }

    tags = {
        Name = "${var.tag-prefix}-Public-Route-Table"
    }
}

// Public Subnet Association //
resource "aws_route_table_association" "public_rt_association" {
    count = length(var.public_subnet_id)
    subnet_id = var.public_subnet_id[count.index]
    route_table_id = aws_route_table.public-rt.id
}

#######################
# Private Route Table #
#######################

resource "aws_route_table" "private-rt" {
    vpc_id = var.vpc_id

    route {
      cidr_block = var.cidr_block
      gateway_id = var.nat_gw_id
    }

    tags = {
        Name = "${var.tag-prefix}-Private-Route-Table"
    }
}

// Private Subnet Association //
resource "aws_route_table_association" "private_rt_association" {
    count = length(var.private_subnet_id)
    subnet_id = var.private_subnet_id[count.index]
    route_table_id = aws_route_table.private-rt.id
}