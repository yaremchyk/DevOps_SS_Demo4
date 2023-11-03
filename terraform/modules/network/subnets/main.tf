data "aws_availability_zones" "available" {}

resource "aws_subnet" "public" {
  count                   = var.az_count
  cidr_block              = cidrsubnet(var.vpc_cidr_block, 8, var.az_count + count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  vpc_id                  = var.vpc_id
  map_public_ip_on_launch = true

  tags = {
    Name     = "${var.namespace}-public-subnet-${count.index}-${var.environment}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.internet_gateway_id
  }

  tags = {
    Name     = "${var.namespace}-public-route-table-${var.environment}"
  }
}

resource "aws_route_table_association" "public" {
  count          = var.az_count
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_main_route_table_association" "public_main" {
  vpc_id         = var.vpc_id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "nat_gateway" {
  count = var.az_count
  vpc = "true"

  tags = {
    Name     = "${var.namespace}-eip-${count.index}-${var.environment}"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  count         = var.az_count
  subnet_id     = aws_subnet.public[count.index].id
  allocation_id = aws_eip.nat_gateway[count.index].id

  tags = {
    Name     = "${var.namespace}-nat-gateway-${count.index}-${var.environment}"
  }
}

resource "aws_subnet" "private" {
  count             = var.az_count
  cidr_block        = cidrsubnet(var.vpc_cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id            = var.vpc_id

  tags = {
    Name     = "${var.namespace}-private-subnet-${count.index}-${var.environment}"
  }
}

resource "aws_route_table" "private" {
  count  = var.az_count
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway[count.index].id
  }

  tags = {
    Name     = "${var.namespace}-private-route-table-${count.index}-${var.environment}"
  }
}

resource "aws_route_table_association" "private" {
  count          = var.az_count
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

resource "aws_db_subnet_group" "db" {
  name        = "db "
  description = "Security group for DB"
  subnet_ids = [for subnet in aws_subnet.private : subnet.id]

  tags = {
    Name     = "${var.namespace}-db-subnet-group-${var.environment}"
  }
}