resource "aws_ecs_service" "ecs_name" {
  name            = var.ecr_service_name
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = var.ecs_desired_count

  network_configuration {
    subnets          = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
    security_groups  = [aws_security_group.ecs-sg.id]
    assign_public_ip = false
  }

  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = 1
    base              = 0
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_api.arn # Referência do target group
    container_name   = var.container_name                # Nome do container definido na task definition
    container_port   = var.container_port                          # A porta em que o container está ouvindo
  }

  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200

  # Habilitar o Circuit Breaker
  deployment_circuit_breaker {
    enable = true
    rollback = true
  }

  enable_ecs_managed_tags = true

  lifecycle {
    ignore_changes = [desired_count]
  }

    tags = {
    Environment = var.tag_environment
    Ambiente    = var.tag_ambiente
  }

}
