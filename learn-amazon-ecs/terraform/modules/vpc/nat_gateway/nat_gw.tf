resource "aws_eip" "eip" {
  vpc = true
}

resource "aws_nat_gateway" "gw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = var.subnet_id

  tags = {
    Name = var.name
  }
}