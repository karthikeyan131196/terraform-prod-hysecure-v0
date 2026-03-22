#############################################
# 22 - INTERNAL NETWORK LOAD BALANCER (NLB)
# - Private load balancer
# - Handles DB and internal service traffic
#############################################

#############################################
# INTERNAL NLB
#############################################

resource "aws_lb" "internal_nlb" {
  ###########################################
  # BASIC CONFIGURATION
  ###########################################
  name               = "${var.project_name}-internal-nlb"
  internal           = true
  load_balancer_type = "network"
  ip_address_type    = "ipv4"

  ###########################################
  # NETWORK CONFIGURATION
  ###########################################
  subnets = values(var.subnet_ids)

  ###########################################
  # FEATURES
  ###########################################
  enable_cross_zone_load_balancing = true

  ###########################################
  # TAGGING
  ###########################################
  tags = merge(local.common_tags, {
    Name = "${var.project_name}-internal-lb"
    Type = "internal-nlb"
  })
}

#############################################
# LISTENER - DATABASE (PORT 3306)
#############################################

resource "aws_lb_listener" "listener_db" {
  load_balancer_arn = aws_lb.internal_nlb.arn

  ###########################################
  # LISTENER CONFIGURATION
  ###########################################
  port     = 3306
  protocol = "TCP"

  ###########################################
  # DEFAULT ROUTING ACTION
  ###########################################
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg["db"].arn
  }
}

#############################################
# LISTENER - INFO SERVICE (PORT 939)
#############################################

resource "aws_lb_listener" "listener_info" {
  load_balancer_arn = aws_lb.internal_nlb.arn

  ###########################################
  # LISTENER CONFIGURATION
  ###########################################
  port     = 939
  protocol = "TCP"

  ###########################################
  # DEFAULT ROUTING ACTION
  ###########################################
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg["info"].arn
  }
}