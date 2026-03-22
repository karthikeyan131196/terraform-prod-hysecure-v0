#############################################
# 21 - EXTERNAL NETWORK LOAD BALANCER (NLB)
# - Internet-facing load balancer
# - Handles incoming HTTPS traffic
#############################################

#############################################
# EXTERNAL NLB
#############################################

resource "aws_lb" "external_nlb" {
  ###########################################
  # BASIC CONFIGURATION
  ###########################################
  name               = "${var.project_name}-external-nlb"
  internal           = false
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
    Name = "${var.project_name}-external-lb"
    Type = "external-nlb"
  })
}

#############################################
# LISTENER - HTTPS (PORT 443)
#############################################

resource "aws_lb_listener" "listener_https" {
  load_balancer_arn = aws_lb.external_nlb.arn

  ###########################################
  # LISTENER CONFIGURATION
  ###########################################
  port     = 443
  protocol = "TCP"

  ###########################################
  # DEFAULT ROUTING ACTION
  ###########################################
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg["https"].arn
  }
}