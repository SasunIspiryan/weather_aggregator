variable "environment" {
  description = "Environment name used for tagging"
  type        = string
  default     = "production"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.2.0/24"]
}

variable "availability_zones" {
  description = "Availability zones for subnet placement"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "instance_type" {
  description = "EC2 instance type for app servers"
  type        = string
  default     = "t3.micro"
}

variable "min_size" {
  description = "Autoscaling group minimum size"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Autoscaling group maximum size"
  type        = number
  default     = 4
}

variable "desired_capacity" {
  description = "Autoscaling group desired size"
  type        = number
  default     = 2
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
}

variable "db_password" {
  description = "Database password for the weather application"
  type        = string
  sensitive   = true
}
