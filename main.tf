#############################################
# 02 - DATA SOURCES (EXISTING RESOURCES)
# - Fetch existing AWS resources
# - VPC components are reused (no creation)
#############################################

# Existing Security Group
data "aws_security_group" "existing" {
  id = var.security_group_id
}

# Existing Key Pair
data "aws_key_pair" "existing" {
  key_name = var.key_pair_name
}

# Existing Subnets
data "aws_subnet" "existing" {
  for_each = var.subnet_ids
  id       = each.value
}

#############################################
# 03 - LOCAL VALUES
# - Derived mappings and reusable values
#############################################

locals {
  ###########################################
  # AZ → Subnet Mapping
  # Example:
  # ap-south-1a → subnet-xxx
  ###########################################
  subnet_by_az = {
    for k, v in data.aws_subnet.existing :
    v.availability_zone => v.id
  }

  ###########################################
  # Common Tags (applied to all resources)
  ###########################################
  common_tags = {
    Project     = var.project_name
    ManagedBy   = "Terraform"
    Environment = "Production"
  }
}