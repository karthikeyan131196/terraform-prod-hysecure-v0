#############################################
# 90 - OUTPUT VALUES
# - Exposes key infrastructure details
# - Used for validation, debugging, and integration
#############################################

#############################################
# NETWORK DETAILS
#############################################

output "vpc_id" {
  description = "VPC ID used for deployment"
  value       = var.vpc_id
}

output "subnet_ids" {
  description = "Subnet IDs mapped per AZ"
  value       = var.subnet_ids
}

output "security_group_id" {
  description = "Security Group attached to EC2 and ENI"
  value       = var.security_group_id
}

#############################################
# EC2 DETAILS
#############################################

output "instance_ids" {
  description = "EC2 instance IDs by role"
  value = {
    for k, v in aws_instance.nodes :
    k => v.id
  }
}

output "private_ips" {
  description = "EC2 private IPs by role"
  value = {
    for k, v in aws_instance.nodes :
    k => v.private_ip
  }
}

#############################################
# LOAD BALANCER DETAILS
#############################################

output "internal_nlb_dns" {
  description = "Internal NLB DNS name"
  value       = aws_lb.internal_nlb.dns_name
}

output "external_nlb_dns" {
  description = "External NLB DNS name"
  value       = aws_lb.external_nlb.dns_name
}

#############################################
# VIP DETAILS
#############################################

output "vip_ips" {
  description = "VIP private IPs per AZ"

  value = {
    az1 = aws_network_interface.vip_az1a.private_ip
    az2 = aws_network_interface.vip_az1b.private_ip
  }
}