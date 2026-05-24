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

  vpc_id           = module.networking.vpc_id
  subnet_ids       = module.networking.public_subnet_ids
  environment      = var.environment
  instance_type    = var.instance_type
  min_size         = var.min_size
  max_size         = var.max_size
  desired_capacity = var.desired_capacity
  repo_url         = var.repo_url
  rds_endpoint     = var.rds_endpoint
  db_name          = var.db_name
  db_username      = var.db_username
  db_password      = var.db_password
}

variable "db_username" {
  description = "Master username for the RDS PostgreSQL instance"
  type        = string
  default     = "postgres"
}

variable "db_password" {
  description = "Master password for the RDS PostgreSQL instance"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "Initial PostgreSQL database name"
  type        = string
  default     = "weather_db"
}

variable "repo_url" {
  description = "Git repository URL to clone on application EC2"
  type        = string
  default     = "https://github.com/SasunIspiryan/weather_aggregator.git"
}

variable "app_instance_type" {
  description = "EC2 instance type for the application host"
  type        = string
  default     = "t3.micro"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "main-vpc"
  }
}

moved {
  from = aws_subnet.public
  to   = module.networking.aws_subnet.public[0]
}

moved {
  from = aws_subnet.public_secondary
  to   = module.networking.aws_subnet.public[1]
}

resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1c"

  tags = {
    Name = "private-subnet-2"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

moved {
  from = aws_route_table.public
  to   = module.networking.aws_route_table.public
}

moved {
  from = aws_route_table.private
  to   = module.networking.aws_route_table.private
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_2" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private.id
}

moved {
  from = aws_route_table_association.public
  to   = module.networking.aws_route_table_association.public[0]
}

moved {
  from = aws_route_table_association.public_secondary
  to   = module.networking.aws_route_table_association.public[1]
}

resource "aws_security_group" "app_sg" {
  name        = "app-sg"
  description = "Allow HTTP and SSH access to app host"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
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
    Name = "app-sg"
  }
}

resource "aws_security_group" "db_sg" {
  name        = "db-sg"
  description = "Allow PostgreSQL access from app security group"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "PostgreSQL from app-sg"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "db-sg"
  }
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

resource "aws_db_subnet_group" "weather_db_subnets" {
  name       = "weather-db-subnet-group"
  subnet_ids = [aws_subnet.private.id, aws_subnet.private_2.id]

  tags = {
    Name = "weather-db-subnet-group"
  }
}

resource "aws_db_instance" "weather_db" {
  identifier              = "weather-db"
  allocated_storage       = 20
  max_allocated_storage   = 20
  storage_type            = "gp3"
  engine                  = "postgres"
  instance_class          = "db.t3.micro"
  db_name                 = var.db_name
  username                = var.db_username
  password                = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.weather_db_subnets.name
  vpc_security_group_ids  = [aws_security_group.db_sg.id]
  publicly_accessible     = false
  skip_final_snapshot     = true
  backup_retention_period = 0

  tags = {
    Name = "weather-rds"
  }
}

resource "aws_instance" "app" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.app_instance_type
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.app_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              set -eux

              apt-get update
              apt-get install -y git docker.io docker-compose-plugin
              systemctl enable --now docker

              install -d -m 755 /opt/weather
              cd /opt/weather

              if [ ! -d weather_aggregator ]; then
                git clone ${var.repo_url}
              fi

              cd weather_aggregator

              DB_ENDPOINT='${aws_db_instance.weather_db.endpoint}'
              DB_HOST="$${DB_ENDPOINT%:*}"
              DB_PORT="$${DB_ENDPOINT##*:}"

              cat > .env <<ENVVARS
              POSTGRES_USER=${var.db_username}
              POSTGRES_PASSWORD=${var.db_password}
              POSTGRES_DB=${var.db_name}
              POSTGRES_HOST=$${DB_HOST}
              POSTGRES_PORT=$${DB_PORT}
              DATABASE_URL=postgres://${var.db_username}:${var.db_password}@${aws_db_instance.weather_db.endpoint}/${var.db_name}
              ENVVARS

              docker compose down || true
              docker compose up -d --build
              EOF

  tags = {
    Name = "weather-app-ec2"
  }
}

output "app_public_ip" {
  value = aws_instance.app.public_ip
}

output "rds_endpoint" {
  value = aws_db_instance.weather_db.endpoint
}
