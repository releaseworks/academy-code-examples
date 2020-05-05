data "template_file" "user_data" {
  template = file("${path.module}/templates/user_data.sh")

  vars = {
    ecs_cluster = module.ecs_cluster.name
  }
}

data "aws_ami" "amz_image" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }

  owners = ["amazon"]
}