data "aws_region" "current" {}
locals {
  //TODO - add a variable for the number of AZs to use, and make this use data
  // availability zones in use for each region
  // this could in theory use data.aws_availability_zones however we'd have to be a little bit more careful to ensure
  // things like the ordering remaining consistent, handling new zones being added etc.
  availability_zones = tomap({
    "eu-west-1" = ["eu-west-1a", "eu-west-1b"]
  })[data.aws_region.current.name]
}

#####
# VPC
#####
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
}

# An Internet gateway differs from a NAT gateway in that it is not associated with a specific subnet. Instead, it is attached to a VPC.
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id
}

module "az-1" {
  source = "../vpc_az"
  availability_zone = local.availability_zones[0]
  vpc_id = aws_vpc.vpc.id

  public_subnet_cidr = var.public_subnet_cidr_1
  private_subnet_cidr = var.private_subnet_cidr_1

  public_route_table_id = aws_route_table.public.id
  private_route_table_id = aws_route_table.private.id
}

module "az-2" {
  source = "../vpc_az"
  availability_zone = local.availability_zones[1]
  vpc_id = aws_vpc.vpc.id

  public_subnet_cidr = var.public_subnet_cidr_2
  private_subnet_cidr = var.private_subnet_cidr_2

  public_route_table_id = aws_route_table.public.id
  private_route_table_id = aws_route_table.private.id
}
