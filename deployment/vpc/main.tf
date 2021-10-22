locals {
  security_groups = {
    public = {
      name        = "public_security_group"
      description = "Security group for public access"
      ingress = {
        ssh = {
          from        = 22
          to          = 22
          protocol    = "tcp"
          cidr_blocks = [var.access_ip]
        }
        http = {
          from        = 80
          to          = 80
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
      }
    }
    rds = {
      name        = "rds_security_group"
      description = "Security group for RDS access"
      ingress = {
        rds = {
          from        = 3306
          to          = 3306
          protocol    = "tcp"
          cidr_blocks = [var.vpc_cidr_block]
        }
      }
    }
  }
}

module "networking" {
  source           = "../../modules/networking"
  vpc_cidr_block   = var.vpc_cidr_block
  access_ip        = var.access_ip
  security_groups  = local.security_groups
  public_sn_count  = 2
  private_sn_count = 3
  max_subnets      = 10
  public_cidrs     = [for i in range(2, 255, 2) : cidrsubnet(var.vpc_cidr_block, 8, i)]
  private_cidrs    = [for i in range(1, 255, 2) : cidrsubnet(var.vpc_cidr_block, 8, i)]
  db_subnet_group  = true
}

# module "database" {
#   source                 = "../../modules/database"
#   db_storage             = 10
#   db_engine_version      = "8.0.20"
#   db_instance_class      = "db.t2.micro"
#   db_name                = var.db_name
#   db_username            = var.db_username
#   db_password            = var.db_password
#   db_identifier          = "utopia-db"
#   skip_final_snapshot    = true
#   db_subnet_group_name   = module.networking.db_subnet_group_name[0]
#   vpc_security_group_ids = module.networking.vpc_security_group_ids
# }

module "loadbalancing" {
  source                 = "../../modules/loadbalancing"
  public_sg              = module.networking.public_security_group
  public_subnets         = module.networking.public_subnets
  tg_port                = 80
  tg_protocol            = "HTTP"
  vpc_id                 = module.networking.vpc_id
  lb_healthy_threshold   = 2
  lb_unhealthy_threshold = 2
  lb_timeout             = 3
  lb_interval            = 30
  listener_port          = 80
  listener_protocol      = "HTTP"
}

module "compute" {
  source = "../../modules/compute"
  instance_count = 1
  instance_type = "t2.micro"
  public_sg = module.networking.public_security_group
  public_subnets = module.networking.public_subnets
  vol_size = 10
  key_name = "utopiakey"
  public_key_path = "/Users/iainrobertson/.ssh/keyutopia.pub"
}