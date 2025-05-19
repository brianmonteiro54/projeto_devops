resource "aws_ecs_task_definition" "task_definition" {
  family                   = var.container_name
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.ecs_cpu
  memory                   = var.ecs_memory
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole_TF.arn
  task_role_arn            = aws_iam_role.ecsSecretManagerAndParameterStore.arn
  tags = {
    Environment = var.tag_environment
    Ambiente    = var.tag_ambiente
  }
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }

  container_definitions = jsonencode([{
    name      = var.container_name
    image     = aws_ecr_repository.app_ecr.repository_url
    essential = true
    portMappings = [{
      containerPort = var.container_port
      hostPort      = var.container_port
      protocol      = "tcp"
      appProtocol   = "http"
      name          = "api-3000"
    }]
    environment = [{
      name  = "PORT"
      value = tostring(var.container_port)
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
        valueFrom = format("%s:username::", tolist(aws_db_instance.rds.master_user_secret)[0].secret_arn)
      },
      {
        name      = "DB_PASSWORD"
        valueFrom = format("%s:password::", tolist(aws_db_instance.rds.master_user_secret)[0].secret_arn)
      }
    ]

    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = "/ecs/${var.container_name}"
        "awslogs-region"        = data.aws_region.current.name
        "awslogs-stream-prefix" = "ecs"
        "mode"                  = "non-blocking"
        "awslogs-create-group"  = "true"
        "max-buffer-size"       = "25m"
      }
    }
  }])
}
