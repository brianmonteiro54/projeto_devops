resource "aws_ecr_repository" "app_ecr" {
  name                 = var.ecr_name
  image_tag_mutability = "MUTABLE"
  force_delete         = true #Força deletar as imagem de container quando faz o destroy
  image_scanning_configuration {
    scan_on_push = true # Habilita o scan de imagem quando a imagem é enviada para o repositório
  }

  tags = {
    Environment = var.tag_environment
    Ambiente    = var.tag_ambiente
  }
}

# Adicionando configuração de escaneamento para o repositório
resource "aws_ecr_registry_scanning_configuration" "app_ecr_scanning" {
  scan_type = "ENHANCED" # Usar escaneamento aprimorado

  rule {
    scan_frequency = "CONTINUOUS_SCAN" # escaneamento contínuo
    repository_filter {
      filter      = var.ecr_name
      filter_type = "WILDCARD"
    }
  }
}

# política de ciclo de vida
resource "aws_ecr_lifecycle_policy" "app_ecr_lifecycle" {
  repository = aws_ecr_repository.app_ecr.name

  policy = <<EOF
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Expirar imagens se a contagem for maior que 20",
      "selection": {
        "tagStatus": "any",
        "countType": "imageCountMoreThan",
        "countNumber": 20
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOF
}
