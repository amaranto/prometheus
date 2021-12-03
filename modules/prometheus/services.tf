resource "aws_ecs_service" "prom_service" {
  name            = var.serviceName
  cluster         = var.clusterId
  task_definition = aws_ecs_task_definition.prom.arn
  desired_count   = var.serviceDesideredAccount
  launch_type     = var.serviceLaunchType

  network_configuration {
    security_groups = [ aws_security_group.prom.id ]
    subnets         = var.serviceSubnets 
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.prom.id
    container_name   = var.promContainerName
    container_port   = var.promContainerPort == null ? var.promPort : var.promContainerPort
  }

  depends_on = [aws_lb_listener.prom]
}

resource "aws_ecs_service" "kibana_service" {
  name            = var.kibanaServiceName
  cluster         = var.clusterId
  task_definition = aws_ecs_task_definition.kibana.0.arn
  desired_count   = 1
  launch_type     = var.kibanaSvcLaunchType

  network_configuration {
    security_groups = [ aws_security_group.kibana.0.id ]
    subnets         = var.kibanaSvcSubnets 
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.kibana.0.id
    container_name   = var.kibanaContainerName
    container_port   = var.kibanaContainerPort == null ? var.kibanaPort : var.kibanaContainerPort
  }

  depends_on = [aws_lb_listener.kibana]
}