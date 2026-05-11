data "aws_ssm_parameter" "amazon_linux_2023_ami" {
  # Resolve the latest public Amazon Linux AMI published by AWS.
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

# Discover the active AWS region for this deployment.
data "aws_region" "current" {}

# Discover the current AWS account ID for IAM policy ARN construction.
data "aws_caller_identity" "current" {}

resource "aws_iam_role" "app" {
  # Name of the EC2 instance role used by application instances.
  name = "weather-app-ec2-role"

  # Trust policy that allows EC2 service to assume this role.
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
  # Inline policy name attached to the EC2 role.
  name = "weather-app-ssm-read"
  # Bind the policy to the application EC2 role.
  role = aws_iam_role.app.id

  # Grant read access only to expected SSM parameter path prefix.
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
  # Instance profile name referenced by the launch template.
  name = "weather-app-ec2-profile"
  # Associate the EC2 role with the instance profile.
  role = aws_iam_role.app.name
}

resource "aws_security_group" "alb" {
  # Security group for the internet-facing ALB.
  name = "alb-sg"
  # Human-readable intent for this ALB security group.
  description = "Allow HTTP inbound traffic to the ALB"
  # Place this security group in the target VPC.
  vpc_id = var.vpc_id

  ingress {
    # Allow inbound HTTP to the load balancer.
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    # Allow outbound traffic to all destinations/ports.
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    # Resource name tag for visibility in AWS console.
    Name = "alb-sg"
  }
}

resource "aws_security_group" "app" {
  # Security group for EC2 application instances.
  name = "app-sg"
  # Restrict inbound access to traffic coming from ALB only.
  description = "Allow traffic from the ALB to application instances"
  # Place this security group in the same VPC as compute.
  vpc_id = var.vpc_id

  ingress {
    # HTTP inbound path from ALB to instances.
    description     = "HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    # Allow instances to reach internet services (apt/yum, APIs, etc.).
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    # Resource name tag for visibility in AWS console.
    Name = "app-sg"
  }
}

resource "aws_lb" "main" {
  # Application Load Balancer name.
  name = "weather-alb"
  # Internet-facing ALB.
  internal = false
  # Explicitly select ALB type.
  load_balancer_type = "application"
  # Attach ALB security group.
  security_groups = [aws_security_group.alb.id]
  # Deploy ALB across provided subnets.
  subnets = var.subnet_ids

  tags = {
    # Resource name tag for visibility in AWS console.
    Name = "weather-alb"
  }
}

resource "aws_lb_target_group" "app" {
  # Target group name for EC2 instance targets.
  name = "weather-tg"
  # Port on instance the ALB forwards to.
  port = 80
  # HTTP protocol for target connections.
  protocol = "HTTP"
  # Register EC2 instances directly.
  target_type = "instance"
  # Target group lives in this VPC.
  vpc_id = var.vpc_id

  health_check {
    # Enable health checks to manage target availability.
    enabled = true
    # Health endpoint path.
    path = "/"
    # Health check protocol.
    protocol = "HTTP"
    # Accept only HTTP 200 as healthy.
    matcher = "200"
    # Consecutive successes before healthy.
    healthy_threshold = 2
    # Consecutive failures before unhealthy.
    unhealthy_threshold = 2
    # Seconds between health checks.
    interval = 30
    # Per-check timeout in seconds.
    timeout = 5
  }

  tags = {
    # Resource name tag for visibility in AWS console.
    Name = "weather-tg"
  }
}

resource "aws_lb_listener" "http" {
  # Bind listener to ALB ARN.
  load_balancer_arn = aws_lb.main.arn
  # Listen on standard HTTP port.
  port = 80
  # Listener protocol.
  protocol = "HTTP"

  default_action {
    # Forward requests to application target group.
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}

resource "aws_launch_template" "app" {
  # Prefix for launch template versions.
  name_prefix = "weather-app-"
  # Use latest AMI value from SSM parameter lookup.
  image_id = data.aws_ssm_parameter.amazon_linux_2023_ami.value
  # Instance type provided by module input.
  instance_type = var.instance_type

  lifecycle {
    # Avoid forced replacement when AMI parameter value shifts.
    ignore_changes = [image_id]
  }

  # Attach application instance security group.
  vpc_security_group_ids = [aws_security_group.app.id]

  iam_instance_profile {
    # Attach instance profile with SSM read permissions.
    name = aws_iam_instance_profile.app.name
  }

  # Cloud-init bootstrap script for application instance provisioning.
  user_data = base64encode(<<-EOF
    #!/bin/bash
    # Fail fast on command, unset variable, and pipe errors.
    set -euxo pipefail

    # Install runtime dependencies used by the deployment script.
    yum install -y docker git awscli
    # Start Docker at boot and now.
    systemctl enable --now docker
    # Allow ec2-user to run Docker commands.
    usermod -aG docker ec2-user

    # Ensure Docker CLI plugin path exists.
    mkdir -p /usr/local/lib/docker/cli-plugins
    # Install Docker Compose plugin binary.
    curl -SL https://github.com/docker/compose/releases/download/v2.29.1/docker-compose-linux-x86_64 -o /usr/local/lib/docker/cli-plugins/docker-compose
    # Make Docker Compose binary executable.
    chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

    # Set local checkout path for application repository.
    APP_DIR="/opt/weather_aggregator"
    # Clone application repository once on first boot.
    if [ ! -d "$APP_DIR" ]; then
      git clone "${var.repo_url}" "$APP_DIR"
    fi

    # Enter application repository directory.
    cd "$APP_DIR"

    # Resolve database username from SSM Parameter Store.
    DB_USERNAME=$(aws ssm get-parameter --region us-east-1 --name "${var.db_username_ssm_parameter_name}" --query Parameter.Value --output text)
    # Resolve database password from SSM Parameter Store with decryption.
    DB_PASSWORD=$(aws ssm get-parameter --region us-east-1 --name "${var.db_password_ssm_parameter_name}" --with-decryption --query Parameter.Value --output text)

    # Render application environment file consumed by docker-compose.
    printf 'APP_ENV=production\nAPP_VERSION=1.0.0\nPOSTGRES_HOST=%s\nPOSTGRES_PORT=5432\nPOSTGRES_DB=%s\nPOSTGRES_USER=%s\nPOSTGRES_PASSWORD=%s\n' "${var.rds_endpoint != "" ? var.rds_endpoint : "postgres"}" "${var.db_name}" "$${DB_USERNAME}" "$${DB_PASSWORD}" > .env

    # Expose app container on port 80 for ALB health checks.
    sed -i 's/"8080:80"/"80:80"/' docker-compose.yml
    # Replace static database user with environment substitution.
    sed -i 's/POSTGRES_USER: postgres/POSTGRES_USER: $${POSTGRES_USER}/' docker-compose.yml
    # Replace static database password with environment substitution.
    sed -i 's/POSTGRES_PASSWORD: postgres/POSTGRES_PASSWORD: $${POSTGRES_PASSWORD}/' docker-compose.yml
    # Replace static database name with environment substitution.
    sed -i 's/POSTGRES_DB: weather_db/POSTGRES_DB: $${POSTGRES_DB}/' docker-compose.yml
    # Replace static database host with environment substitution.
    sed -i 's/POSTGRES_HOST: postgres/POSTGRES_HOST: $${POSTGRES_HOST}/' docker-compose.yml

    # Launch or update containers in detached mode.
    docker compose up -d
    EOF
  )

  tag_specifications {
    # Apply tags to EC2 instances created by this launch template.
    resource_type = "instance"

    tags = {
      # Resource name tag for visibility in AWS console.
      Name = "weather-app-instance"
    }
  }
}

resource "aws_autoscaling_group" "app" {
  # Name of Auto Scaling Group managing app instances.
  name = "weather-asg"
  # Minimum number of instances.
  min_size = var.min_size
  # Maximum number of instances.
  max_size = var.max_size
  # Desired steady-state capacity.
  desired_capacity = var.desired_capacity
  # Subnets where ASG can place instances.
  vpc_zone_identifier = var.subnet_ids
  # Register ASG instances with target group.
  target_group_arns = [aws_lb_target_group.app.arn]
  # Use ELB health checks for instance replacement decisions.
  health_check_type = "ELB"

  launch_template {
    # Reference launch template ID for instance config.
    id = aws_launch_template.app.id
    # Always use latest launch template version.
    version = "$Latest"
  }

  tag {
    # Instance Name tag key.
    key = "Name"
    # Instance Name tag value.
    value = "weather-app-instance"
    # Ensure tag is copied to launched instances.
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "cpu_target_tracking" {
  # Policy name for target tracking auto scaling.
  name = "weather-cpu-target-tracking"
  # Attach scaling policy to app ASG.
  autoscaling_group_name = aws_autoscaling_group.app.name
  # Use target tracking policy type.
  policy_type = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      # Scale based on average ASG CPU utilization.
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    # Maintain approximately 50% average CPU.
    target_value = 50.0
  }
}
