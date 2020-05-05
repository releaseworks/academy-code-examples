resource "aws_autoscaling_group" "asg" {
  name                 = var.name
  vpc_zone_identifier  = var.vpc_zones
  max_size             = var.max_size
  min_size             = var.min_size
  launch_configuration = aws_launch_configuration.launch_config.name
}

resource "aws_launch_configuration" "launch_config" {
  name                        = var.config_name
  image_id                    = var.image_id
  instance_type               = var.instance_type
  user_data                   = var.user_data
  iam_instance_profile        = var.iam_instance_profile
  security_groups             = var.security_groups
  associate_public_ip_address = var.public_address
}

