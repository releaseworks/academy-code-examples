provider "aws" {
  version = ">= 2.28.1"
  region  = "eu-west-1"
}

# Security group to allow internal database traffic
resource "aws_security_group" "db-sg" {
  name        = "db-sg"
  description = "allow internal database traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "TLS from VPC"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  egress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  tags = {
    Name = "db-sg"
  }
}

# VPC for our wordpress deployment
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "simple-example"

  cidr = "10.0.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b", "euwest-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_ipv6 = true

  enable_nat_gateway = true
  single_nat_gateway = true

  public_subnet_tags = {
    Name = "public"
  }

  tags = {
    Owner       = "releaseworks-academy"
    Environment = "dev"
  }

  vpc_tags = {
    Name = "wordpress-vpc"
  }
}


module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 2.0"

  identifier = "wordpress-db"

  engine            = "mysql"
  engine_version    = "5.7.19"
  instance_class    = "db.t2.small"
  allocated_storage = 10
  storage_encrypted = false

  name     = "wordpress-db"
  username = "mysqladmin"
  password = "acrypticpassword"
  port     = "3306"

  vpc_security_group_ids = [aws_security_group.db-sg.id]

  maintenance_window = "Sun:00:00-Sun:03:00"
  backup_window      = "03:00-06:00"

  multi_az = true

  backup_retention_period = 7

  tags = {
    Owner       = "user"
    Environment = "dev"
  }

  enabled_cloudwatch_logs_exports = ["audit", "general"]

  subnet_ids = module.vpc.private_subnets

  family = "mysql5.7"

  major_engine_version = "5.7"

  deletion_protection = false

  parameters = [
    {
      name  = "character_set_client"
      value = "utf8"
    },
    {
      name  = "character_set_server"
      value = "utf8"
    }
  ]

  options = [
    {
      option_name = "MARIADB_AUDIT_PLUGIN"

      option_settings = [
        {
          name  = "SERVER_AUDIT_EVENTS"
          value = "CONNECT"
        },
        {
          name  = "SERVER_AUDIT_FILE_ROTATIONS"
          value = "37"
        },
      ]
    },
  ]
}