terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "taskflow-terraform-state-bucket"
    key            = "environments/staging/terraform.tfstate"
    region         = "ap-southeast-1"
    encrypt        = true
    dynamodb_table = "taskflow-terraform-locks"
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "taskflow"
      Environment = "staging"
      ManagedBy   = "Terraform"
      Owner       = "Jatupat kuseng"
    }
  }
}
