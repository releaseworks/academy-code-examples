variable "region" {
  default = "eu-west-1"
}

variable "app_name" {
  description = "Name of application"
}

# VPC variables
variable "vpc_cidr" {
  description = "Cidr block for VPC"
}

# Load Balancer variables
variable "lb_type" {
  default     = "application"
  description = "Load Balancer type. Can be application, network or classic"
}

variable "lb_listener_port" {
  default     = 80
  description = "Load balancer's listening port"
}

variable "lb_listener_protocol" {
  default     = "HTTP"
  description = "Load balancer's protocol"
}

variable "http_listener_action" {
  default     = "forward"
  description = "Listener's action. Can be forward, redirect, fixed-response, authenticate-cognito or authenticate-oidc"
}

variable "tg_port" {
  description = "Port used target group"
}

variable "tg_protocol" {
  description = "Target group's protocol"
}

variable "tg_type" {
  description = "Type of the target group. Can be ip or instance"
}

variable "sg_type_ingress" {
  default = "ingress"
}

variable "all_cidr_block" {
  default = "0.0.0.0/0"
}

variable "tcp_protocol" {
  default = "tcp"
}

# ECS variables
variable "launch_type" {
  description = "ECS launch type. Either EC2 or Fargate"
}

variable "sg_type_egress" {
  default = "egress"
}

variable "role_service" {

}

variable "public_address" {
  default = "false"
}

variable "container_port" {

}

variable "host_port" {
  default = 0
}

variable "port_8000" {
  default = 8000
}

variable "ecr_policy" {
  default = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

variable "ecs_task_policy" {
  default = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

variable "desired_tasks" {

}

variable "network_mode" {

}

variable "cpu" {

}

variable "memory" {

}

variable "task_role_service" {
  default = "ecs-tasks.amazonaws.com"
}

# EC2 Cluster specific variables
variable "instance_type" {
  default = ""
}

variable "ecs_policy" {
  default = ""
}

variable "max_instance_size" {
  default = ""
}

variable "min_instance_size" {
  default = ""
}