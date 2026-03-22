#############################################
# 11 - VIP (ELASTIC NETWORK INTERFACES)
# - Provides static private IPs per AZ
# - Used for failover / floating IP design
#############################################

#############################################
# VIP ENI - AZ1 (ap-south-1a)
#############################################

resource "aws_network_interface" "vip_az1a" {
  subnet_id       = var.subnet_ids["az1"]
  security_groups = [data.aws_security_group.existing.id]

  ###########################################
  # TAGGING
  ###########################################
  tags = merge(local.common_tags, {
    Name = "${var.project_name}-vip-az1a"
    Role = "vip"
  })
}

#############################################
# VIP ENI - AZ2 (ap-south-1b)
#############################################

resource "aws_network_interface" "vip_az1b" {
  subnet_id       = var.subnet_ids["az2"]
  security_groups = [data.aws_security_group.existing.id]

  ###########################################
  # TAGGING
  ###########################################
  tags = merge(local.common_tags, {
    Name = "${var.project_name}-vip-az1b"
    Role = "vip"
  })
}