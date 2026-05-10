data "aws_ssm_parameter" "amazon_linux_2023_ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

resource "aws_iam_role" "app" {
  name = "weather-app-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "app_ssm_read" {
  name = "weather-app-ssm-read"
  role = aws_iam_role.app.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["ssm:GetParameter"]
        Resource = "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/project-weather/*"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "app" {
  name = "weather-app-ec2-profile"
  role = aws_iam_role.app.name
}

resource "aws_security_group" "alb" {
  name        = "alb-sg"
  description = "Allow HTTP inbound traffic to the ALB"
  vpc_id      = var.vpc_id

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
  vpc_id      = var.vpc_id

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
  subnets            = var.subnet_ids

  tags = {
    Name = "weather-alb"
  }
}

resource "aws_lb_target_group" "app" {
  name        = "weather-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id

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
  instance_type = var.instance_type

  lifecycle {
    ignore_changes = [image_id]
  }

  vpc_security_group_ids = [aws_security_group.app.id]

  iam_instance_profile {
    name = aws_iam_instance_profile.app.name
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    set -euxo pipefail

    yum update -y
    yum install -y docker git awscli
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

  DB_USERNAME=$(aws ssm get-parameter --name "${var.db_username_ssm_parameter_name}" --query Parameter.Value --output text)
  DB_PASSWORD=$(aws ssm get-parameter --name "${var.db_password_ssm_parameter_name}" --with-decryption --query Parameter.Value --output text)

    cat > .env <<ENVVARS
    APP_ENV=production
    APP_VERSION=1.0.0
    POSTGRES_HOST=${var.rds_endpoint}
    POSTGRES_PORT=5432
    POSTGRES_DB=${var.db_name}
  POSTGRES_USER=$${DB_USERNAME}
  POSTGRES_PASSWORD=$${DB_PASSWORD}
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
  min_size            = var.min_size
  max_size            = var.max_size
  desired_capacity    = var.desired_capacity
  vpc_zone_identifier = var.subnet_ids
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
