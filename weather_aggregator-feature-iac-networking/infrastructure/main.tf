module "networking" {
  source = "./modules/networking"

  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  environment          = var.environment
  availability_zones   = var.availability_zones
}

resource "aws_ssm_parameter" "db_username" {
  name  = "/project-weather/db-username"
  type  = "String"
  value = var.db_username

  tags = {
    Name = "project-weather-db-username"
  }
}

resource "aws_ssm_parameter" "db_password" {
  name  = "/project-weather/db-password"
  type  = "SecureString"
  value = var.db_password

  tags = {
    Name = "project-weather-db-password"
  }
}

module "compute" {
  source = "./modules/compute"

  vpc_id                         = module.networking.vpc_id
  subnet_ids                     = module.networking.public_subnet_ids
  environment                    = var.environment
  instance_type                  = var.instance_type
  min_size                       = var.min_size
  max_size                       = var.max_size
  desired_capacity               = var.desired_capacity
  repo_url                       = var.repo_url
  rds_endpoint                   = var.rds_endpoint
  db_name                        = var.db_name
  db_username                    = var.db_username
  db_password                    = var.db_password
  db_username_ssm_parameter_name = aws_ssm_parameter.db_username.name
  db_password_ssm_parameter_name = aws_ssm_parameter.db_password.name
}

moved {
  from = aws_vpc.main
  to   = module.networking.aws_vpc.main
}

moved {
  from = aws_subnet.public
  to   = module.networking.aws_subnet.public[0]
}

moved {
  from = aws_subnet.public_secondary
  to   = module.networking.aws_subnet.public[1]
}

moved {
  from = aws_subnet.private
  to   = module.networking.aws_subnet.private[0]
}

moved {
  from = aws_internet_gateway.main
  to   = module.networking.aws_internet_gateway.main
}

moved {
  from = aws_route_table.public
  to   = module.networking.aws_route_table.public
}

moved {
  from = aws_route_table.private
  to   = module.networking.aws_route_table.private
}

moved {
  from = aws_route_table_association.public
  to   = module.networking.aws_route_table_association.public[0]
}

moved {
  from = aws_route_table_association.public_secondary
  to   = module.networking.aws_route_table_association.public[1]
}

moved {
  from = aws_route_table_association.private
  to   = module.networking.aws_route_table_association.private[0]
}

moved {
  from = aws_security_group.alb
  to   = module.compute.aws_security_group.alb
}

moved {
  from = aws_security_group.app
  to   = module.compute.aws_security_group.app
}

moved {
  from = aws_lb.main
  to   = module.compute.aws_lb.main
}

moved {
  from = aws_lb_target_group.app
  to   = module.compute.aws_lb_target_group.app
}

moved {
  from = aws_lb_listener.http
  to   = module.compute.aws_lb_listener.http
}

moved {
  from = aws_launch_template.app
  to   = module.compute.aws_launch_template.app
}

moved {
  from = aws_autoscaling_group.app
  to   = module.compute.aws_autoscaling_group.app
}

moved {
  from = aws_autoscaling_policy.cpu_target_tracking
  to   = module.compute.aws_autoscaling_policy.cpu_target_tracking
}