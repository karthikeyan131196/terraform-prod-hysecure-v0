vpc_id = "vpc-0cec3aae18043a6db"

subnet_ids = {
  az1 = "subnet-06db34bb52a3f8913"
  az2 = "subnet-09463d55a518f28f5"
}

security_group_id = "sg-080cea7acb6cf1caf"
key_pair_name     = "Mainkey_South_1"

instance_az_map = {
  active  = "ap-south-1a"
  standby = "ap-south-1b"
  real-1 = "ap-south-1a"
}

ami_id           = "ami-0caa6d72e7d3af20d"
instance_type    = "t3.medium"
root_volume_size = 65
project_name     = "hysecure-prod"