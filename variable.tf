# Region 
variable "aws_region" {
  description = "AWS Region"
  type        = string
}

# Vpc 

variable "vpc_id" {
  type = string
}

# Subnets
variable "subnet_ids" {
  type = map(string)
}

# Security Group
variable "security_group_id" {
  type = string
}

# Key Pair
variable "key_pair_name" {
  type = string
}

# EC2 Mapping (AZ)
variable "instance_az_map" {
  type = map(string)
}

# AMI
variable "ami_id" {
  type = string
}

# Instance Type
variable "instance_type" {
  type = string
}

# Root Volume
variable "root_volume_size" {
  type = number
}

# Project Name
variable "project_name" {
  type = string
}