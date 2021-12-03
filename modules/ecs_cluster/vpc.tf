data "aws_availability_zones" "available_zones" {
  state = "available"
}

resource "aws_vpc" "default" {
  count = var.vpc_id == null ? 1 : 0
  cidr_block = var.vpc_cidr
}

resource "aws_subnet" "public" {
  count = var.vpc_id == null ? var.public_subnets_amount : 0
  cidr_block              = cidrsubnet(aws_vpc.default.0.cidr_block, 8, 2 + count.index)
  availability_zone       = data.aws_availability_zones.available_zones.names[count.index]
  vpc_id                  = aws_vpc.default.0.id
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private" {
  count = var.vpc_id == null ? var.private_subnets_amount : 0
  cidr_block        = cidrsubnet(aws_vpc.default.0.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available_zones.names[count.index]
  vpc_id            = aws_vpc.default.0.id
}

resource "aws_internet_gateway" "gateway" {
  count = var.vpc_id == null ? 1 : 0
  vpc_id = aws_vpc.default.0.id
}

resource "aws_route" "internet_access" {
  count = var.vpc_id == null ? 1 : 0
  route_table_id         = aws_vpc.default.0.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gateway.0.id
}

resource "aws_eip" "gateway" {
  count = var.vpc_id == null ? var.nat_gw_amount : 0
  vpc        = true
  depends_on = [aws_internet_gateway.gateway.0]
}

resource "aws_nat_gateway" "gateway" {
  count = var.vpc_id == null ? var.nat_gw_amount : 0
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  allocation_id = element(aws_eip.gateway.*.id, count.index)
}

resource "aws_route_table" "private" {
  count = var.vpc_id == null ? var.nat_gw_amount : 0
  vpc_id = aws_vpc.default.0.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.gateway.*.id, count.index)
  }
}

resource "aws_route_table_association" "private" {
  count = var.vpc_id == null ? var.nat_gw_amount : 0
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}