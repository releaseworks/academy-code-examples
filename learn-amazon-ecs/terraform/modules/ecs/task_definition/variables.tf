variable "name" {
  description = "Task definition name"
}

variable "launch_type" {
  description = "Launch type. EC2 or FARGATE"
}

variable "definitions" {
  description = "Container definitions in Json format"
}

variable "network_mode" {
  default = "bridge"
}

variable "cpu" {
  default = ""
}

variable "memory" {
  default = ""
}

variable "execution_role" {
  default = ""
}



