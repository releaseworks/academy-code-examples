resource "aws_route_table" "route_table" {
  vpc_id = var.vpc_id

  tags = {
    Name = var.name
  }
}

resource "aws_route_table_association" "table_association" {
  count          = length(var.subnets)
  subnet_id      = element(var.subnets, count.index)
  route_table_id = aws_route_table.route_table.id
}
