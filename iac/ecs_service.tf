resource "aws_ecs_service" "api_production" {
  name            = var.ecr_service_name
  cluster         = aws_ecs_cluster.production.id
  task_definition = aws_ecs_task_definition.api_production.arn
  desired_count   = 2

  network_configuration {
    subnets          = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
    security_groups  = [aws_security_group.api-ecs.id]
    assign_public_ip = false
  }

  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = 1
    base              = 0
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_api.arn # Referência do target group
    container_name   = "api-production"                # Nome do container definido na task definition
    container_port   = 3000                            # A porta em que o container está ouvindo
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

}
