resource "aws_ecs_service" "service" {
  name = var.name
  cluster = var.cluster
  task_definition = var.task_definition
  desired_count = var.desired_count
  launch_type = var.launch_type
  load_balancer {
    target_group_arn = var.lb_target_group
    container_name   = var.container_name
    container_port   = var.container_port
  }

}
