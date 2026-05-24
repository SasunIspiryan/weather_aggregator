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
