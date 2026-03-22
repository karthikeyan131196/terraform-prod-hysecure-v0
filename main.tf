locals {
  subnet_by_az = {
    for k, v in data.aws_subnet.existing :
    v.availability_zone => v.id
  }

  common_tags = {
    Project     = var.project_name
    ManagedBy   = "Accops"
    Environment = "Production"
  }
}
