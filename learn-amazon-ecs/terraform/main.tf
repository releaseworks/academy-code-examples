# # Shared ECS modules
module "hellonode_repository" {
  source          = "./modules/ecs/ecr"
  repository_name = var.app_name
}

module "ecs_cluster" {
  source = "./modules/ecs/cluster"
  name   = var.app_name
}

module "task_definition" {
  source         = "./modules/ecs/task_definition"
  name           = var.app_name
  launch_type    = [var.launch_type]
  network_mode   = var.network_mode
  cpu            = var.cpu
  memory         = var.memory
  execution_role = module.task_execution_role.arn
  definitions = templatefile("definitions/container_definition.json", {
    repository_url  = module.hellonode_repository.repository_url
    definition_name = "${var.app_name}-${var.launch_type}"
    container_port  = var.container_port
    host_port       = var.host_port
  })
}

module "ecs_service" {
  source          = "./modules/ecs/service"
  name            = "${var.app_name}-${var.launch_type}-service"
  cluster         = module.ecs_cluster.id
  task_definition = module.task_definition.arn
  desired_count   = var.desired_tasks
  launch_type     = var.launch_type
  lb_target_group = module.target_group.arn
  container_name  = "${var.app_name}-${var.launch_type}"
  container_port  = var.container_port
  # Change this local variable to ec2_network_config when creating an EC2 cluster
  network_config  = local.ec2_network_config
  http_listener   = module.http_listener.arn
}

module "task_execution_role" {
  source  = "./modules/ecs/iam"
  name    = "${var.app_name}-execution-role"
  service = var.task_role_service
}

module "execution_role_ecr" {
  source     = "./modules/ecs/role_policy_attachment"
  role       = module.task_execution_role.name
  policy_arn = var.ecr_policy
}

module "execution_role_ecs" {
  source     = "./modules/ecs/role_policy_attachment"
  role       = module.task_execution_role.name
  policy_arn = var.ecs_task_policy
}

module "ecs_sg" {
  source = "./modules/vpc/sg"
  name   = "${var.app_name}-sg"
  vpc_id = module.vpc.id
}

module "ingress_sg_rule" {
  source         = "./modules/vpc/sg_rule_sg"
  type           = var.sg_type_ingress
  from_port      = var.host_port
  to_port        = var.host_port
  source_sg      = module.lb_sg.id
  protocol       = var.tcp_protocol
  security_group = module.ecs_sg.id
}

module "ec2_egress_sg_rule" {
  source         = "./modules/vpc/sg_rule_cidr"
  type           = var.sg_type_egress
  from_port      = 0
  to_port        = 65535
  cidr_block     = [var.all_cidr_block]
  protocol       = var.tcp_protocol
  security_group = module.ecs_sg.id
}

# EC2 modules
module "instance_role" {
  source  = "./modules/ecs/iam"
  name    = var.app_name
  service = var.role_service
}

module "ecs_policy" {
  source     = "./modules/ecs/role_policy_attachment"
  role       = module.instance_role.name
  policy_arn = var.ecs_policy
}

module "instance_profile" {
  source = "./modules/ecs/instance_profile"
  name   = "${var.app_name}-instance-profile"
  role   = module.instance_role.name
}

module "ec2_instances" {
  source               = "./modules/ecs/asg"
  name                 = var.app_name
  vpc_zones            = module.vpc.private_subnet_ids
  max_size             = var.max_instance_size
  min_size             = var.min_instance_size
  config_name          = var.app_name
  image_id             = data.aws_ami.amz_image.id
  public_address       = var.public_address
  instance_type        = var.instance_type
  user_data            = data.template_file.user_data.rendered
  iam_instance_profile = module.instance_profile.name
  security_groups      = [module.ecs_sg.id]
}


# VPC modules
module "vpc" {
  source     = "./modules/vpc/vpc"
  name       = "${var.app_name}-vpc"
  cidr_block = var.vpc_cidr
}

module "internet_gateway" {
  source = "./modules/vpc/internet_gateway"
  vpc_id = module.vpc.id
  name   = "${var.app_name}-ig"
}

module "nat_gateway" {
  source    = "./modules/vpc/nat_gateway"
  subnet_id = element(module.vpc.public_subnet_ids, 1)
  name      = "${var.app_name}-nat_gw"
}

module "public_route_table" {
  source  = "./modules/vpc/route_table"
  vpc_id  = module.vpc.id
  name    = "${var.app_name}-public-table"
  subnets = module.vpc.public_subnet_ids
}

module "public_internet_gw_route" {
  source           = "./modules/vpc/route"
  route_table_id   = module.public_route_table.id
  destination_cidr = "0.0.0.0/0"
  gateway_id       = module.internet_gateway.id
}

module "private_route_table" {
  source  = "./modules/vpc/route_table"
  vpc_id  = module.vpc.id
  name    = "${var.app_name}-private-table"
  subnets = module.vpc.private_subnet_ids
}

module "private_nat_gw_route" {
  source           = "./modules/vpc/route"
  route_table_id   = module.private_route_table.id
  destination_cidr = "0.0.0.0/0"
  gateway_id       = module.nat_gateway.id
}

# Load balancer modules
module "load_balancer" {
  source     = "./modules/alb/load_balancer"
  name       = var.app_name
  lb_type    = var.lb_type
  lb_sg      = [module.lb_sg.id]
  lb_subnets = module.vpc.public_subnet_ids
}

module "target_group" {
  source      = "./modules/alb/target_group"
  name        = "${var.app_name}-tg"
  port        = var.tg_port
  protocol    = var.tg_protocol
  target_type = var.tg_type
  vpc_id      = module.vpc.id
}

module "http_listener" {
  source      = "./modules/alb/lb_listener"
  lb_arn      = module.load_balancer.arn
  port        = var.lb_listener_port
  protocol    = var.lb_listener_protocol
  action_type = var.http_listener_action
  tg_arn      = module.target_group.arn
}

module "lb_sg" {
  source = "./modules/vpc/sg"
  name   = "${var.app_name}-lb"
  vpc_id = module.vpc.id
}

module "lb_ingress_http_rule" {
  source         = "./modules/vpc/sg_rule_cidr"
  type           = var.sg_type_ingress
  from_port      = 80
  to_port        = 80
  cidr_block     = [var.all_cidr_block]
  protocol       = var.tcp_protocol
  security_group = module.lb_sg.id
}

module "lb_egress_sg_rule" {
  source         = "./modules/vpc/sg_rule_cidr"
  type           = var.sg_type_egress
  from_port      = 0
  to_port        = 65535
  cidr_block     = [var.all_cidr_block]
  protocol       = var.tcp_protocol
  security_group = module.lb_sg.id
}
