module "networking" {
  # Source path for reusable networking module.
  source = "./modules/networking"

  # Base CIDR block used to create the VPC.
  vpc_cidr = var.vpc_cidr
  # CIDR blocks for public subnets.
  public_subnet_cidrs = var.public_subnet_cidrs
  # CIDR blocks for private subnets.
  private_subnet_cidrs = var.private_subnet_cidrs
  # Environment label passed through to module resources.
  environment = var.environment
  # AZs where subnets are created.
  availability_zones = var.availability_zones
}

resource "aws_ssm_parameter" "db_username" {
  # Fixed SSM path used by compute bootstrap script.
  name = "/project-weather/db-username"
  # Store plain username as String parameter.
  type = "String"
  # Username value provided via root variable.
  value = var.db_username

  tags = {
    # Name tag for easier parameter identification.
    Name = "project-weather-db-username"
  }
}

resource "aws_ssm_parameter" "db_password" {
  # Fixed SSM path used by compute bootstrap script.
  name = "/project-weather/db-password"
  # Store password as encrypted secure string.
  type = "SecureString"
  # Password value provided via sensitive root variable.
  value = var.db_password

  tags = {
    # Name tag for easier parameter identification.
    Name = "project-weather-db-password"
  }
}

module "compute" {
  # Source path for reusable compute module.
  source = "./modules/compute"

  # VPC ID output from networking module.
  vpc_id = module.networking.vpc_id
  # Public subnet IDs where ALB and ASG are deployed.
  subnet_ids = module.networking.public_subnet_ids
  # Environment label passed into compute resources.
  environment = var.environment
  # EC2 instance type for launch template.
  instance_type = var.instance_type
  # Minimum ASG size.
  min_size = var.min_size
  # Maximum ASG size.
  max_size = var.max_size
  # Desired ASG capacity.
  desired_capacity = var.desired_capacity
  # Repository cloned by cloud-init.
  repo_url = var.repo_url
  # External DB endpoint; empty triggers local postgres fallback.
  rds_endpoint = var.rds_endpoint
  # Database name injected into app env file.
  db_name = var.db_name
  # SSM parameter name for runtime DB username fetch.
  db_username_ssm_parameter_name = aws_ssm_parameter.db_username.name
  # SSM parameter name for runtime DB password fetch.
  db_password_ssm_parameter_name = aws_ssm_parameter.db_password.name
}

moved {
  # Preserve state after moving VPC resource into networking module.
  from = aws_vpc.main
  to   = module.networking.aws_vpc.main
}

moved {
  # Preserve state after moving first public subnet into networking module.
  from = aws_subnet.public
  to   = module.networking.aws_subnet.public[0]
}

moved {
  # Preserve state after moving second public subnet into networking module.
  from = aws_subnet.public_secondary
  to   = module.networking.aws_subnet.public[1]
}

moved {
  # Preserve state after moving private subnet into networking module.
  from = aws_subnet.private
  to   = module.networking.aws_subnet.private[0]
}

moved {
  # Preserve state after moving internet gateway into networking module.
  from = aws_internet_gateway.main
  to   = module.networking.aws_internet_gateway.main
}

moved {
  # Preserve state after moving public route table into networking module.
  from = aws_route_table.public
  to   = module.networking.aws_route_table.public
}

moved {
  # Preserve state after moving private route table into networking module.
  from = aws_route_table.private
  to   = module.networking.aws_route_table.private
}

moved {
  # Preserve state after moving first public route association into networking module.
  from = aws_route_table_association.public
  to   = module.networking.aws_route_table_association.public[0]
}

moved {
  # Preserve state after moving second public route association into networking module.
  from = aws_route_table_association.public_secondary
  to   = module.networking.aws_route_table_association.public[1]
}

moved {
  # Preserve state after moving private route association into networking module.
  from = aws_route_table_association.private
  to   = module.networking.aws_route_table_association.private[0]
}

moved {
  # Preserve state after moving ALB security group into compute module.
  from = aws_security_group.alb
  to   = module.compute.aws_security_group.alb
}

moved {
  # Preserve state after moving app security group into compute module.
  from = aws_security_group.app
  to   = module.compute.aws_security_group.app
}

moved {
  # Preserve state after moving ALB into compute module.
  from = aws_lb.main
  to   = module.compute.aws_lb.main
}

moved {
  # Preserve state after moving target group into compute module.
  from = aws_lb_target_group.app
  to   = module.compute.aws_lb_target_group.app
}

moved {
  # Preserve state after moving listener into compute module.
  from = aws_lb_listener.http
  to   = module.compute.aws_lb_listener.http
}

moved {
  # Preserve state after moving launch template into compute module.
  from = aws_launch_template.app
  to   = module.compute.aws_launch_template.app
}

moved {
  # Preserve state after moving ASG into compute module.
  from = aws_autoscaling_group.app
  to   = module.compute.aws_autoscaling_group.app
}

moved {
  # Preserve state after moving scaling policy into compute module.
  from = aws_autoscaling_policy.cpu_target_tracking
  to   = module.compute.aws_autoscaling_policy.cpu_target_tracking
}