################
# Public Subnet
################
resource "aws_subnet" "public" {
  vpc_id = var.vpc_id

  cidr_block = var.public_subnet_cidr
  availability_zone = var.availability_zone
  map_public_ip_on_launch = true
}

resource "aws_route_table_association" "public" {
  subnet_id = aws_subnet.public.id
  route_table_id = var.public_route_table_id
}

##################
# Private Subnet
##################
resource "aws_subnet" "private" {
  vpc_id = var.vpc_id

  cidr_block = var.private_subnet_cidr
  availability_zone = var.availability_zone
}

resource "aws_route_table_association" "private" {
  count = var.nat_gateway ? 0 : 1
  subnet_id = aws_subnet.private.id
  route_table_id = var.private_route_table_id
}


##############
# NAT Instance
##############

resource "aws_eip" "nat_gateway" {
  count = var.nat_gateway ? 1 : 0
  domain = "vpc"
}

# We need one of these if we want to allow our private subnets to access the internet. Our ECS tasks need internet access to pull images from ECR, unless we set up a VPC endpoint for ECR.
resource "aws_nat_gateway" "nat_gateway" {
  count = var.nat_gateway ? 1 : 0

  allocation_id = aws_eip.nat_gateway[0].id
  subnet_id = aws_subnet.public.id
}

# We need the extra route table because different subnets have their own NAT gateway.
resource "aws_route_table" "private_subnet" {
  count = var.nat_gateway ? 1 : 0

  vpc_id = var.vpc_id

  # Route all traffic out through the NAT gateway - the route table for the public subnets will then route it through the internet gateway.
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway[0].id
  }
}

resource "aws_route_table_association" "private_subnet" {
  count = var.nat_gateway ? 1 : 0

  subnet_id = aws_subnet.private.id
  route_table_id = aws_route_table.private_subnet[0].id
}
