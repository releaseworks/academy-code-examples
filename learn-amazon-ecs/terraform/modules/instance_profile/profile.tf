resource "aws_iam_instance_profile" "profile" {
  name = var.name
  role = var.role
}