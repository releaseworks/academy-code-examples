locals {
  fargate_network_config = [
    {
      subnets         = module.vpc.private_subnet_ids
      public_ip       = "false"
      security_groups = [module.ecs_sg.id]
    }
  ]
  ec2_network_config = []
}