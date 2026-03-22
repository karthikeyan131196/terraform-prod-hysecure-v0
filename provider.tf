#############################################
# 00 - TERRAFORM & PROVIDER CONFIGURATION
# - Defines Terraform version
# - Configures AWS provider
#############################################

terraform {
  ###########################################
  # Required Terraform Version
  ###########################################
  required_version = ">= 1.5"

  ###########################################
  # Required Providers
  ###########################################
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

#############################################
# AWS PROVIDER CONFIGURATION
#############################################

provider "aws" {
  region = var.aws_region

  ###########################################
  # Default Tags (applied to all resources)
  ###########################################
  default_tags {
    tags = {
      Project     = var.project_name
      ManagedBy   = "Terraform"
      Environment = "Production"
    }
  }
}
