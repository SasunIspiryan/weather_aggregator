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
  image_id      = var.golden_ami_id
  instance_type = var.instance_type
  iam_instance_profile {
    name = var.iam_instance_profile
  }

  vpc_security_group_ids = [aws_security_group.app.id]

  user_data = base64encode(<<-EOF
    #!/bin/bash
    set -euxo pipefail

    systemctl enable --now docker
    until docker info >/dev/null 2>&1; do
      sleep 2
    done

    APP_DIR="/opt/weather_aggregator"
    rm -rf "$APP_DIR"
    git clone --depth 1 "${var.repo_url}" "$APP_DIR"

    cd "$APP_DIR"

    DB_USERNAME=$$(aws ssm get-parameter --name "/project-weather/db-username" --query Parameter.Value --output text --region us-east-1)
    DB_PASSWORD=$$(aws ssm get-parameter --name "/project-weather/db-password" --with-decryption --query Parameter.Value --output text --region us-east-1)

    docker build -t weather-aggregator:latest .
    docker rm -f weather-aggregator >/dev/null 2>&1 || true
    docker run -d \
      --name weather-aggregator \
      --restart unless-stopped \
      -p 80:5000 \
      -e APP_ENV=production \
      -e APP_VERSION=1.0.0 \
      -e POSTGRES_HOST=${var.rds_endpoint} \
      -e POSTGRES_PORT=5432 \
      -e POSTGRES_DB=${var.db_name} \
      -e POSTGRES_USER=$$DB_USERNAME \
      -e POSTGRES_PASSWORD=$$DB_PASSWORD \
      weather-aggregator:latest
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
