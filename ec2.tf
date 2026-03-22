resource "aws_instance" "nodes" {
  for_each = var.instance_az_map

  ami           = var.ami_id
  instance_type = var.instance_type

  subnet_id              = local.subnet_by_az[each.value]
  vpc_security_group_ids = [data.aws_security_group.existing.id]

  key_name = data.aws_key_pair.existing.key_name

  associate_public_ip_address = false

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = "gp3"
  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${each.key}"
    Role = each.key
  })
}