variable "vpc_id" {
  description = "VPC ID from the networking module"
  type        = string
}

variable "subnet_ids" {
  description = "Public subnet IDs for ALB and ASG"
  type        = list(string)
}

variable "environment" {
  description = "Environment name for tagging"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "min_size" {
  description = "ASG minimum size"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "ASG maximum size"
  type        = number
  default     = 4
}

variable "desired_capacity" {
  description = "ASG desired capacity"
  type        = number
  default     = 2
}

variable "repo_url" {
  description = "Git repository URL for application bootstrap"
  type        = string
}

variable "rds_endpoint" {
  description = "RDS endpoint hostname used by the weather application"
  type        = string
}

variable "db_name" {
  description = "Database name for the weather application"
  type        = string
}

variable "db_username" {
  description = "Database username for the weather application"
  type        = string
}

variable "db_password" {
  description = "Database password for the weather application"
  type        = string
  sensitive   = true
}

variable "db_username_ssm_parameter_name" {
  description = "SSM parameter name that stores the DB username"
  type        = string
}

variable "db_password_ssm_parameter_name" {
  description = "SSM parameter name that stores the DB password"
  type        = string
}
