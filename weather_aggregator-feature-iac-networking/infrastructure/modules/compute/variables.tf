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

variable "golden_ami_id" {
  description = "Golden AMI ID that already contains Docker, Git, AWS CLI, and jq"
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

variable "iam_instance_profile" {
  description = "IAM instance profile name for EC2 instances to access SSM parameters"
  type        = string
}
