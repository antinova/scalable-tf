resource "aws_subnet" "private" {
  for_each = { for idx, subnet in var.private_subnets : idx => subnet }

  vpc_id            = aws_vpc.item.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone

  tags = merge(
    { Name = "${var.vpc_name}-private-${each.key}" },
    var.private_subnet_tags
  )
}

resource "aws_subnet" "public" {
  for_each = { for idx, subnet in var.public_subnets : idx => subnet }

  vpc_id            = aws_vpc.item.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone

  tags = merge(
    { Name = "${var.vpc_name}-public-${each.key}" },
    var.public_subnet_tags
  )
}
