module "hellonode_repository" {
  source = "./modules/ecr"
  repository_name = "hellonode"
}

module "ecs_cluster" {
  source = "./modules/cluster"
  name = "hellonode"
}

module "ec2_task_definition" {
  source = "./modules/task_definition"
  name = "hellonode-ec2"
  launch_type = ["EC2"]
  definitions = templatefile("definitions/ec2_definition.json", {
    repository_url = module.hellonode_repository.repository_url
  })
}

module "instance_role" {
  source = "./modules/iam"
  name = "hellonode"
}

module "ecs_policy" {
  source = "./modules/role_policy_attachment"
  role = module.instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

module "instance_profile" {
  source = "./modules/instance_profile"
  name = "hellonode-instance-profile"
  role = module.instance_role.name
}

module "ec2_sg" {
  source = "./modules/sg"
  name = "hellonode-ec2-sg"
  vpc_id = module.ec2_vpc.id
}

module "ec2_ingress_sg_rule" {
  source = "./modules/sg_rule_sg"
  type = "ingress"
  from_port = 80
  to_port = 80
  source_sg = module.lb_sg.id
  protocol = "tcp"
  security_group = module.ec2_sg.id
}

module "ec2_egress_sg_rule" {
  source = "./modules/sg_rule_cidr"
  type = "egress"
  from_port = 0
  to_port = 65535
  cidr_block = ["0.0.0.0/0"]
  protocol = "tcp"
  security_group = module.ec2_sg.id
}

module "ec2_instances" {
  source = "./modules/asg"
  name = "hellonode"
  vpc_zones = module.ec2_vpc.public_subnet_ids
  max_size = 3
  min_size = 1
  config_name = "hellonode"
  image_id = data.aws_ami.amz_image.id
  instance_type = "t2.micro"
  user_data = data.template_file.user_data.rendered
  iam_instance_profile = module.instance_profile.name
  security_groups = [module.ec2_sg.id]
}



module "ec2_service" {
  source = "./modules/service"
  name = "ec2-service"
  cluster = module.ecs_cluster.id
  task_definition = module.ec2_task_definition.arn
  desired_count = 1
  launch_type = "EC2"
  lb_target_group = module.target_group.arn
  container_name = "ec2_definition"
  container_port = 8000
}

# module "fargate_task_definition" {
#   source = "./modules/task_definition"
#   name = "hellonode-fargate"
#   launch_type = ["FARGATE"]
#   definitions = templatefile("definitions/fargate_definition.json", {
#     repository_url = module.hellonode_repository.repository_url
#   })
# }

# module "fargate_service" {
#   source = "./modules/service"
#   name = "fargate-service"
#   cluster = module.ecs_cluster.id
#   task_definition = module.fargate_task_definition.arn
#   desired_count = 2
#   launch_type = "FARGATE"
#   load_balancer = []
# }

module "ec2_vpc" {
  source = "./modules/vpc"
  name = "EC2-hellonode"
  cidr_block = "10.0.0.0/16"
}

module "internet_gateway" {
  source = "./modules/internet_gateway"
  vpc_id = module.ec2_vpc.id
  name = "Hellonode-ig"
}

module "nat_gateway" {
  source = "./modules/nat_gateway"
  subnet_id = element(module.ec2_vpc.public_subnet_ids, 1)
  name = "Hellonode-natgw"
}


module "public_route_table" {
  source = "./modules/route_table"
  vpc_id = module.ec2_vpc.id
  name = "Hellonode-public-table"
  subnets = module.ec2_vpc.public_subnet_ids
}

module "public_internet_gw_route" {
  source = "./modules/route"
  route_table_id = module.public_route_table.id
  destination_cidr = "0.0.0.0/0"
  gateway_id = module.internet_gateway.id
}

module "private_route_table" {
  source = "./modules/route_table"
  vpc_id = module.ec2_vpc.id
  name = "Hellonode-private-table"
  subnets = module.ec2_vpc.private_subnet_ids
}

module "private_nat_gw_route" {
  source = "./modules/route"
  route_table_id = module.private_route_table.id
  destination_cidr = "0.0.0.0/0"
  gateway_id = module.nat_gateway.id
}

module "load_balancer" {
  source = "./modules/load_balancer"
  name = "hellonode"
  lb_type = "application"
  lb_sg = [module.lb_sg.id]
  lb_subnets = module.ec2_vpc.public_subnet_ids
}

module "target_group" {
  source = "./modules/target_group"
  name = "hellonode"
  port = 80
  protocol = "HTTP"
  target_type = "instance"
  vpc_id = module.ec2_vpc.id
}

module "http_listener" {
  source = "./modules/lb_listener"
  lb_arn = module.load_balancer.arn
  port = 80
  protocol = "HTTP"
  action_type = "forward"
  tg_arn = module.target_group.arn
  
}


module "lb_sg" {
  source = "./modules/sg"
  name = "Hellonode lb"
  vpc_id = module.ec2_vpc.id
}

module "lb_ingress_sg_rule" {
  source = "./modules/sg_rule_cidr"
  type = "ingress"
  from_port = 80
  to_port = 80
  cidr_block = ["0.0.0.0/0"]
  protocol = "tcp"
  security_group = module.lb_sg.id
}

module "lb_egress_sg_rule" {
  source = "./modules/sg_rule_cidr"
  type = "egress"
  from_port = 0
  to_port = 65535
  cidr_block = ["0.0.0.0/0"]
  protocol = "tcp"
  security_group = module.lb_sg.id
}
