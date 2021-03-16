resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc-name
  }
}

resource "aws_subnet" "public_subnet" {
  count = length(data.aws_availability_zones.azs.names)

  availability_zone = element(data.aws_availability_zones.azs.names, count.index)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.${0 + count.index}.0/24"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.vpc-name} Internet Gateway"
  }
}

resource "aws_route_table" "internet_route" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.vpc-name} Route Table"
  }
}

resource "aws_main_route_table_association" "main_route_table_association" {
  vpc_id         = aws_vpc.vpc.id
  route_table_id = aws_route_table.internet_route.id
}
