resource "aws_iam_role_policy" "ecs_log_policy" {
  name = "ecs-prom-policy"
  role = aws_iam_role.task_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role" "task_role" {
  name = "ecs-prom-roles"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_ecs_task_definition" "prom" {
  family                   = var.family
  network_mode             = var.networkMode
  requires_compatibilities = var.compatibilities
  cpu                      = var.cpu
  memory                   = var.memory
  task_role_arn            = aws_iam_role.task_role.arn
  execution_role_arn       = aws_iam_role.task_role.arn
  container_definitions = var.promDefinition == null ? local.defaultPromDefinition : var.promDefinition
}

resource "aws_security_group" "prom" {
  name        = "${var.family}-sg"
  vpc_id      =  var.vpcId

  ingress {
    protocol        = var.sgProtocol
    from_port       = var.promPort
    to_port         = var.promPort
    cidr_blocks     = var.sgPromCidr
    ipv6_cidr_blocks = var.sgPromCidr6
    security_groups = flatten([ var.sgPromSgIds, [aws_security_group.lb.0.id] ])
  }

  egress {
    protocol    = var.sgPromEgressProtocol
    from_port   = var.sgPromEgressFrom
    to_port     = var.sgPromEgressTo
    cidr_blocks = var.sgPromEgressCidr
    ipv6_cidr_blocks = var.sgPromEgressCidr6
    security_groups = var.sgPromEgressSgIds  
  }
}

resource "aws_ecs_task_definition" "kibana" {
  count = var.enableKibana ? 1 : 0
  family                   = var.family
  network_mode             = var.networkMode
  requires_compatibilities = var.compatibilities
  cpu                      = var.kibanaCpu
  memory                   = var.kibanaMemory
  task_role_arn            = aws_iam_role.task_role.arn
  execution_role_arn       = aws_iam_role.task_role.arn
  container_definitions = var.kibanaDefinition == null ? local.defaultKibanaDefinition : var.kibanaDefinition
}

resource "aws_security_group" "kibana" {
  count = var.enableKibana? 1 : 0
  name        = "${var.family}-kibana-sg"
  vpc_id      =  var.vpcId

  ingress {
    protocol        = var.kibanaSgProtocol
    from_port       = var.kibanaPort
    to_port         = var.kibanaPort
    cidr_blocks     = var.kibanaSgCidr
    ipv6_cidr_blocks = var.kibanaSgCidr6
    security_groups = flatten([ var.kibanaSgSgIds, [aws_security_group.lb.0.id] ])
  }

  egress {
    protocol    = var.kibanaSgEgressProtocol
    from_port   = var.kibanaSgEgressFrom
    to_port     = var.kibanaSgEgressTo
    cidr_blocks = var.kibanaSgEgressCidr
    ipv6_cidr_blocks = var.kibanaSgEgressCidr6
    security_groups = var.kibanaSgEgressSgIds  
  }
}