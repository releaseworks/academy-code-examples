resource "aws_ecs_task_definition" "task" {
  family = var.name
  requires_compatibilities = var.launch_type
  container_definitions = var.definitions
}
