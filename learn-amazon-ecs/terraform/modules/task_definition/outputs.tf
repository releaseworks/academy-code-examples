output "arn" {
  value = aws_ecs_task_definition.task.arn
}

output "name" {
  value = aws_ecs_task_definition.task.family
}
