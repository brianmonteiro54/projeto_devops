resource "aws_ecs_task_definition" "api_production" {
  family                   = "api-production"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.ecs_cpu
  memory                   = var.ecs_memory
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole_TF.arn
  task_role_arn            = aws_iam_role.ecsSecretManagerAndParameterStore.arn

  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }

  container_definitions = jsonencode([{
    name      = "api-production"
    image     = aws_ecr_repository.api_production.repository_url
    essential = true
    portMappings = [{
      containerPort = 3000
      hostPort      = 3000
      protocol      = "tcp"
      appProtocol   = "http"
      name          = "api-3000"
    }]
    environment = [{
      name  = "API_PORT"
      value = "3000"
    }]
    secrets = [
      {
        name      = "DB_ENDPOINT"
        valueFrom = aws_ssm_parameter.db_endpoint.arn
      },
      {
        name      = "DB_DATABASE"
        valueFrom = aws_ssm_parameter.db_database.arn
      },
      {
        name      = "DB_PORT"
        valueFrom = aws_ssm_parameter.db_port.arn
      },
      {
        name      = "DB_USERNAME"
        valueFrom = format("%s:username::", tolist(aws_db_instance.rds_api.master_user_secret)[0].secret_arn)
      },
      {
        name      = "DB_PASSWORD"
        valueFrom = format("%s:password::", tolist(aws_db_instance.rds_api.master_user_secret)[0].secret_arn)
      }
    ]

    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = "/ecs/api-production"
        "awslogs-region"        = data.aws_region.current.name
        "awslogs-stream-prefix" = "ecs"
        "mode"                  = "non-blocking"
        "awslogs-create-group"  = "true"
        "max-buffer-size"       = "25m"
      }
    }
  }])
}
