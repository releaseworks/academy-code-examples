resource "aws_lb" "application_lb" {
  name               = var.name
  load_balancer_type = var.lb_type
  security_groups    = var.lb_sg
  subnets            = var.lb_subnets
}
