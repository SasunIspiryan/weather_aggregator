module "networking" {
  source = "./modules/networking"

  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  environment          = var.environment
  availability_zones   = var.availability_zones
}

module "compute" {
  source = "./modules/compute"

  vpc_id                 = module.networking.vpc_id
  subnet_ids             = module.networking.public_subnet_ids
  environment            = var.environment
  instance_type          = var.instance_type
  min_size               = var.min_size
  max_size               = var.max_size
  desired_capacity       = var.desired_capacity
  repo_url               = var.repo_url
  rds_endpoint           = var.rds_endpoint
  db_name                = var.db_name
  db_username            = var.db_username
  db_password            = var.db_password
  iam_instance_profile   = aws_iam_instance_profile.ec2_ssm_profile.name
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

# ===== Phase 1: SSM Parameter Store for Secrets Management =====

# Store database username in SSM Parameter Store (standard tier - free)
resource "aws_ssm_parameter" "db_username" {
  name  = "/project-weather/db-username"
  type  = "String"
  value = var.db_username

  tags = {
    Name        = "weather-db-username"
    Environment = var.environment
  }
}

# Store database password in SSM Parameter Store with SecureString encryption (free tier with default KMS key)
resource "aws_ssm_parameter" "db_password" {
  name  = "/project-weather/db-password"
  type  = "SecureString"
  value = var.db_password

  tags = {
    Name        = "weather-db-password"
    Environment = var.environment
  }
}

# ===== IAM Role and Policies for EC2 Instances to Access SSM Parameters =====

# IAM Role for EC2 instances
resource "aws_iam_role" "ec2_ssm_role" {
  name = "weather-ec2-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name        = "weather-ec2-ssm-role"
    Environment = var.environment
  }
}

# IAM Policy to allow GetParameter on SSM parameters
resource "aws_iam_role_policy" "ec2_ssm_policy" {
  name = "weather-ec2-ssm-policy"
  role = aws_iam_role.ec2_ssm_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:GetParameter"
        ]
        Resource = [
          aws_ssm_parameter.db_username.arn,
          aws_ssm_parameter.db_password.arn
        ]
      }
    ]
  })
}

# IAM Instance Profile for EC2 instances
resource "aws_iam_instance_profile" "ec2_ssm_profile" {
  name = "weather-ec2-ssm-profile"
  role = aws_iam_role.ec2_ssm_role.name
}