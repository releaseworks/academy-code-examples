resource "aws_security_group" "security_group" {
  name   = var.name
  vpc_id = var.vpc_id
}