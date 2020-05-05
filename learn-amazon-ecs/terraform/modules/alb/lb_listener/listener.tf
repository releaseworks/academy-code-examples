resource "aws_lb_listener" "listener" {
  load_balancer_arn = var.lb_arn
  port              = var.port
  protocol          = var.protocol

  default_action {
    type             = var.action_type
    target_group_arn = var.tg_arn
  }
}
