data "aws_lb" "default" {
  count       = var.elbName == null ? 0:1 
  name = var.elbName
} 

locals {
  sgNetworkIngress = var.sgNetworkIngress != null ? var.sgNetworkIngress : [
    {
      enabled = true 
      protocol    = var.lbSgProtocol
      from_port   = var.elbPromPort == null ? var.promPort : var.elbPromPort
      to_port     = var.elbPromPort == null ? var.promPort : var.elbPromPort
      cidr_blocks     = var.lbSgCidr
      ipv6_cidr_blocks = var.lbSgCidr6
      security_groups = var.lbSgAllowedIds
    },
    {
      enabled = var.enableKibana
      protocol    = var.lbSgProtocol
      from_port   = var.elbKibanaPort == null ? var.kibanaPort : var.elbKibanaPort
      to_port     = var.elbKibanaPort == null ? var.kibanaPort : var.elbKibanaPort
      cidr_blocks     = var.lbSgCidr
      ipv6_cidr_blocks = var.lbSgCidr6
      security_groups = var.lbSgAllowedIds      
    }
  ]
}

resource "aws_security_group" "lb" {
  count       = var.elbName == null ? 1:0
  name        = var.lbSgName
  vpc_id      = var.vpcId

  dynamic "ingress" {
        for_each = [ for ing in local.sgNetworkIngress: ing if ing.enabled ]
        content {
          protocol    = ingress.value.protocol
          from_port   = ingress.value.from_port
          to_port     = ingress.value.to_port
          cidr_blocks     = ingress.value.cidr_blocks
          ipv6_cidr_blocks = ingress.value.ipv6_cidr_blocks
          security_groups = ingress.value.security_groups
        }
  }
  
  egress {
    from_port = var.lbSgEgressFromPort
    to_port   = var.lbSgEgressToPort
    protocol  = var.lbSgEgressProtocol
    cidr_blocks = var.lbSgEgressCidr
  }
}

resource "aws_lb" "default" {
  count       = var.elbName == null ? 1:0
  name            = "${var.baseName}-lb"
  subnets         = var.elbSubnets
  security_groups = [aws_security_group.lb.0.id]
}



resource "aws_lb_target_group" "prom" {
  name        = "${var.baseName}-tg"
  port        = var.promPort
  protocol    = "HTTP"
  vpc_id      = var.vpcId
  target_type = "ip"

  health_check {
    healthy_threshold = var.promHelthThreshold
    interval = var.promHelthInterval
    matcher = var.promHelthMatcher
    path = var.promHelthPath
    port = var.promHelthPort
    protocol = var.promHelthProtocol
    timeout = var.promHelthTimeOut
    unhealthy_threshold = var.promHelthUnhealtyThreshold
  }
}

resource "aws_lb_listener" "prom" {
  load_balancer_arn = var.elbName == null ? aws_lb.default.0.id : data.aws_lb.default.0.id
  port              = var.elbPromPort == null ? var.promPort : var.elbPromPort
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.prom.id
    type             = "forward"
  }
}

resource "aws_lb_target_group" "kibana" {
  count = var.enableKibana ? 1 : 0
  name        = "${var.baseName}-kibana-tg"
  port        = var.kibanaPort
  protocol    = "HTTP"
  vpc_id      = var.vpcId
  target_type = "ip"

  health_check {
    healthy_threshold = var.kibanaHelthThreshold
    interval = var.kibanaHelthInterval
    matcher = var.kibanaHelthMatcher
    path = var.kibanaHelthPath
    port = var.kibanaHelthPort
    protocol = var.kibanaHelthProtocol
    timeout = var.kibanaHelthTimeOut
    unhealthy_threshold = var.kibanaHelthUnhealtyThreshold
  }
}

resource "aws_lb_listener" "kibana" {
  count = var.enableKibana ? 1 : 0
  load_balancer_arn = var.elbName == null ? aws_lb.default.0.id : data.aws_lb.default.0.id
  port              = var.elbKibanaPort == null ? var.kibanaPort : var.elbKibanaPort
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.kibana.0.id
    type             = "forward"
  }
}
