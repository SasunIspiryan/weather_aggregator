terraform {
  required_version = ">= 1.10.0"

  backend "s3" {
    bucket       = "project-weather-tf-state-930458520014-74713"
    key          = "project/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_ssm_parameter" "amazon_linux_2023_ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

variable "repo_url" {
  description = "Git repository URL for application bootstrap"
  type        = string
  default     = "https://github.com/SasunIspiryan/weather_aggregator.git"
}

variable "rds_endpoint" {
  description = "RDS endpoint hostname used by the weather application"
  type        = string
  default     = ""
}

variable "db_name" {
  description = "Database name for the weather application"
  type        = string
  default     = "weather_db"
}

variable "db_username" {
  description = "Database username for the weather application"
  type        = string
  default     = "postgres"
}

variable "db_password" {
  description = "Database password for the weather application"
  type        = string
  sensitive   = true
  default     = "postgres"
}

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "main-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
  }
}

resource "aws_subnet" "public_secondary" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-2"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "private-subnet"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "public-rt"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "private-rt"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_secondary" {
  subnet_id      = aws_subnet.public_secondary.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

resource "aws_security_group" "alb" {
  name        = "alb-sg"
  description = "Allow HTTP inbound traffic to the ALB"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-sg"
  }
}

resource "aws_security_group" "app" {
  name        = "app-sg"
  description = "Allow traffic from the ALB to application instances"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "app-sg"
  }
}

resource "aws_lb" "main" {
  name               = "weather-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = [aws_subnet.public.id, aws_subnet.public_secondary.id]

  tags = {
    Name = "weather-alb"
  }
}

resource "aws_lb_target_group" "app" {
  name        = "weather-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.main.id

  health_check {
    enabled             = true
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 30
    timeout             = 5
  }

  tags = {
    Name = "weather-tg"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}

resource "aws_launch_template" "app" {
  name_prefix   = "weather-app-"
  image_id      = data.aws_ssm_parameter.amazon_linux_2023_ami.value
  instance_type = "t3.micro"

  vpc_security_group_ids = [aws_security_group.app.id]

  user_data = base64encode(<<-EOF
    #!/bin/bash
    set -euxo pipefail

    yum update -y
    yum install -y docker git
    systemctl enable --now docker
    usermod -aG docker ec2-user

    mkdir -p /usr/local/lib/docker/cli-plugins
    curl -SL https://github.com/docker/compose/releases/download/v2.29.1/docker-compose-linux-x86_64 -o /usr/local/lib/docker/cli-plugins/docker-compose
    chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

    APP_DIR="/opt/weather_aggregator"
    if [ ! -d "$APP_DIR" ]; then
      git clone "${var.repo_url}" "$APP_DIR"
    fi

    cd "$APP_DIR"

    cat > .env <<ENVVARS
    APP_ENV=production
    APP_VERSION=1.0.0
    POSTGRES_HOST=${var.rds_endpoint}
    POSTGRES_PORT=5432
    POSTGRES_DB=${var.db_name}
    POSTGRES_USER=${var.db_username}
    POSTGRES_PASSWORD=${var.db_password}
    ENVVARS

    sed -i 's/"8080:80"/"80:80"/' docker-compose.yml
    sed -i 's/POSTGRES_USER: postgres/POSTGRES_USER: $${POSTGRES_USER}/' docker-compose.yml
    sed -i 's/POSTGRES_PASSWORD: postgres/POSTGRES_PASSWORD: $${POSTGRES_PASSWORD}/' docker-compose.yml
    sed -i 's/POSTGRES_DB: weather_db/POSTGRES_DB: $${POSTGRES_DB}/' docker-compose.yml
    sed -i 's/POSTGRES_HOST: postgres/POSTGRES_HOST: $${POSTGRES_HOST}/' docker-compose.yml

    docker compose up -d
    EOF
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "weather-app-instance"
    }
  }
}

resource "aws_autoscaling_group" "app" {
  name                = "weather-asg"
  min_size            = 2
  max_size            = 4
  desired_capacity    = 2
  vpc_zone_identifier = [aws_subnet.public.id, aws_subnet.public_secondary.id]
  target_group_arns   = [aws_lb_target_group.app.arn]
  health_check_type   = "ELB"

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "weather-app-instance"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "cpu_target_tracking" {
  name                   = "weather-cpu-target-tracking"
  autoscaling_group_name = aws_autoscaling_group.app.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 50.0
  }
}

output "alb_dns_name" {
  description = "DNS name of the application load balancer"
  value       = aws_lb.main.dns_name
}