#############################################
# 10 - EC2 INSTANCES
# - Multi-AZ deployment
# - Active / Standby / Additional nodes
# - Uses existing VPC, Subnets, SG, Key Pair
#############################################

resource "aws_instance" "nodes" {
  for_each = var.instance_az_map

  ###########################################
  # AMI & INSTANCE CONFIGURATION
  ###########################################
  ami           = var.ami_id
  instance_type = var.instance_type

  ###########################################
  # NETWORK CONFIGURATION
  ###########################################
  subnet_id              = local.subnet_by_az[each.value]
  vpc_security_group_ids = [data.aws_security_group.existing.id]
  associate_public_ip_address = true   # change to false for private-only setup

  ###########################################
  # ACCESS CONFIGURATION
  ###########################################
  key_name = data.aws_key_pair.existing.key_name

  ###########################################
  # STORAGE CONFIGURATION
  ###########################################
  root_block_device {
    volume_size = var.root_volume_size
    volume_type = "gp3"
  }

  ###########################################
  # TAGGING
  ###########################################
  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${each.key}"
    Role = each.key
  })
}