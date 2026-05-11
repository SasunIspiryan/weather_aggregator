variable "environment" {
  # Environment label used for resource tagging and naming.
  description = "Environment name used for tagging"
  # Input type for environment value.
  type = string
  # Default environment for this project.
  default = "production"
}

variable "vpc_cidr" {
  # CIDR block assigned to the VPC.
  description = "CIDR block for the VPC"
  # Input type for VPC CIDR.
  type = string
  # Default VPC CIDR for this stack.
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  # CIDR ranges for internet-facing subnets.
  description = "CIDR blocks for public subnets"
  # Input type for subnet CIDR list.
  type = list(string)
  # Default two public subnet ranges.
  default = ["10.0.1.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  # CIDR ranges for private subnets.
  description = "CIDR blocks for private subnets"
  # Input type for private subnet CIDR list.
  type = list(string)
  # Default one private subnet range.
  default = ["10.0.2.0/24"]
}

variable "availability_zones" {
  # Availability zones where subnets/resources are placed.
  description = "Availability zones for subnet placement"
  # Input type for AZ list.
  type = list(string)
  # Default AZ pair for us-east-1 deployment.
  default = ["us-east-1a", "us-east-1b"]
}

variable "instance_type" {
  # EC2 instance type for application instances.
  description = "EC2 instance type for app servers"
  # Input type for instance class.
  type = string
  # Default instance type for cost-effective testing.
  default = "t3.micro"
}

variable "min_size" {
  # Minimum ASG capacity.
  description = "Autoscaling group minimum size"
  # Input type for ASG limits.
  type = number
  # Default minimum size.
  default = 2
}

variable "max_size" {
  # Maximum ASG capacity.
  description = "Autoscaling group maximum size"
  # Input type for ASG limits.
  type = number
  # Default maximum size.
  default = 4
}

variable "desired_capacity" {
  # Desired ASG capacity at steady state.
  description = "Autoscaling group desired size"
  # Input type for desired count.
  type = number
  # Default desired instance count.
  default = 2
}

variable "repo_url" {
  # Git URL used by cloud-init to clone application code.
  description = "Git repository URL for application bootstrap"
  # Input type for repository URL.
  type = string
  # Default repository source.
  default = "https://github.com/SasunIspiryan/weather_aggregator.git"
}

variable "rds_endpoint" {
  # Optional external database hostname.
  description = "RDS endpoint hostname used by the weather application"
  # Input type for endpoint value.
  type = string
  # Empty by default to allow local postgres fallback.
  default = ""
}

variable "db_name" {
  # Logical database name used by application/postgres.
  description = "Database name for the weather application"
  # Input type for database name.
  type = string
  # Default database name.
  default = "weather_db"
}

variable "db_username" {
  # Database username stored in SSM parameter.
  description = "Database username for the weather application"
  # Input type for username.
  type = string
}

variable "db_password" {
  # Database password stored in SSM secure parameter.
  description = "Database password for the weather application"
  # Input type for password.
  type = string
  # Prevent accidental plaintext display in Terraform output.
  sensitive = true
}
