resource "aws_lb_target_group" "target_group" {
  name        = var.name
  port        = var.port
  protocol    = var.protocol
  target_type = var.target_type
  vpc_id      = var.vpc_id
}