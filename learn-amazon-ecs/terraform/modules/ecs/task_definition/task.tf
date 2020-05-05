resource "aws_ecs_task_definition" "task" {
  family                   = var.name
  requires_compatibilities = var.launch_type
  container_definitions    = var.definitions
  network_mode             = var.network_mode
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = var.execution_role
}
