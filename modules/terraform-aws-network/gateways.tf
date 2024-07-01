resource "aws_internet_gateway" "item" {
  vpc_id = aws_vpc.item.id

  tags = {
    Name = "${var.vpc_name}"
  }
}

resource "aws_route" "igw" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.item.id
}

resource "aws_eip" "item" {
  count = length(var.private_subnets)

  domain = "vpc"

  depends_on = [aws_internet_gateway.item]
}

resource "aws_nat_gateway" "item" {
  count = length(var.private_subnets)

  allocation_id = element(aws_eip.item[*].id, count.index)
  subnet_id     = element(flatten([for item in aws_subnet.private : [item.id]]), count.index)

  tags = {
    Name = "${var.vpc_name}-${count.index}"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.item]
}

resource "aws_route" "nat" {
  count = length(var.private_subnets)

  route_table_id         = element(aws_route_table.private[*].id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.item[*].id, count.index)
}
