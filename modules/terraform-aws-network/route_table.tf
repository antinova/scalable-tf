resource "aws_route_table" "private" {
  count = length(var.private_subnets)

  vpc_id = aws_vpc.item.id

  tags = {
    "Name" = "${var.vpc_name}-private-${count.index}"
  }
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  subnet_id      = element(flatten([for item in aws_subnet.private : [item.id]]), count.index)
  route_table_id = element(aws_route_table.private[*].id, count.index)
}


resource "aws_route_table" "public" {
  vpc_id = aws_vpc.item.id

  tags = {
    "Name" = "${var.vpc_name}-public"
  }
}

resource "aws_route_table_association" "public" {
  count          = length(var.private_subnets)
  subnet_id      = element(flatten([for item in aws_subnet.public : [item.id]]), count.index)
  route_table_id = aws_route_table.public.id
}
