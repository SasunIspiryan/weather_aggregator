variable "vpc_id" {
  # VPC identifier where ALB/ASG resources are created.
  description = "VPC ID from the networking module"
  # Expect a single VPC ID string.
  type = string
}

variable "subnet_ids" {
  # Subnet IDs used by ALB and ASG placement.
  description = "Public subnet IDs for ALB and ASG"
  # Expect a list of subnet ID strings.
  type = list(string)
}

variable "environment" {
  # Environment label propagated for naming/tagging conventions.
  description = "Environment name for tagging"
  # Expect a single environment name string.
  type = string
}

variable "instance_type" {
  # EC2 instance size used in launch template.
  description = "EC2 instance type"
  # Expect instance type string (for example t3.micro).
  type = string
  # Default keeps cost low for coursework deployments.
  default = "t3.micro"
}

variable "min_size" {
  # Lower bound for ASG instance count.
  description = "ASG minimum size"
  # Expect numeric value.
  type = number
  # Maintain at least two instances for ALB availability.
  default = 2
}

variable "max_size" {
  # Upper bound for ASG instance count.
  description = "ASG maximum size"
  # Expect numeric value.
  type = number
  # Cap instance growth.
  default = 4
}

variable "desired_capacity" {
  # Steady-state target instance count.
  description = "ASG desired capacity"
  # Expect numeric value.
  type = number
  # Start with two instances.
  default = 2
}

variable "repo_url" {
  # Git repository URL cloned during instance bootstrap.
  description = "Git repository URL for application bootstrap"
  # Expect repository URL string.
  type = string
}

variable "rds_endpoint" {
  # Database host endpoint when using external RDS.
  description = "RDS endpoint hostname used by the weather application"
  # Expect hostname string; empty means local postgres container fallback.
  type = string
}

variable "db_name" {
  # Logical database name consumed by application and postgres service.
  description = "Database name for the weather application"
  # Expect database name string.
  type = string
}

variable "db_username_ssm_parameter_name" {
  # SSM parameter path for database username lookup at boot.
  description = "SSM parameter name that stores the DB username"
  # Expect SSM parameter name string.
  type = string
}

variable "db_password_ssm_parameter_name" {
  # SSM parameter path for database password lookup at boot.
  description = "SSM parameter name that stores the DB password"
  # Expect SSM parameter name string.
  type = string
}
