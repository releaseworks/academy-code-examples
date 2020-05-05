variable "repository_name" {
  description = "Name of the repository"
}

variable "image_mutability" {
  description = "Should image tag be mutable or not"
  default     = "MUTABLE"


}

variable "scan_on_push" {
  description = "Enable scan on push or not"
  default     = "true"
}

