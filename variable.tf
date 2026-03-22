#############################################
# 01 - INPUT VARIABLES
# - Defines all configurable inputs
# - Used across EC2, NLB, TG, and networking
#############################################

#############################################
# AWS CONFIGURATION
#############################################

variable "aws_region" {
  description = "AWS region where resources will be deployed (e.g., ap-south-1)"
  type        = string
}

#############################################
# NETWORK CONFIGURATION (EXISTING INFRA)
#############################################

variable "vpc_id" {
  description = "Existing VPC ID where resources will be deployed"
  type        = string
}

variable "subnet_ids" {
  description = "Map of subnet IDs per AZ (e.g., az1, az2)"
  type        = map(string)
}

variable "security_group_id" {
  description = "Existing Security Group ID to attach to EC2 and ENI"
  type        = string
}

#############################################
# ACCESS CONFIGURATION
#############################################

variable "key_pair_name" {
  description = "Existing AWS key pair name for SSH access"
  type        = string
}

#############################################
# EC2 CONFIGURATION
#############################################

variable "instance_az_map" {
  description = "Mapping of instance roles to availability zones (e.g., active, standby)"
  type        = map(string)
}

variable "ami_id" {
  description = "AMI ID used to launch EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type (e.g., t3.medium)"
  type        = string
}

variable "root_volume_size" {
  description = "Root volume size in GB"
  type        = number
}

#############################################
# PROJECT / TAGGING
#############################################

variable "project_name" {
  description = "Project name used for resource naming and tagging"
  type        = string
}