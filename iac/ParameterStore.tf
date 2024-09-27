# Criando Parameter Store para o DB Name
resource "aws_ssm_parameter" "db_database" {
  name        = "/api/db_database"
  description = "Nome do banco de dados"
  type        = "String"
  value       = aws_db_instance.rds_api.db_name

  tags = {
    "environment" = var.tag_prod
    "ambiente"    = var.tag_ambiente
  }
}

# Criando Parameter Store para o Endpoint do banco
resource "aws_ssm_parameter" "db_endpoint" {
  name        = "/api/db_endpoint"
  description = "Endpoint do banco de dados"
  type        = "String"
  value       = split(":", aws_db_instance.rds_api.endpoint)[0] #Pega apenas o endpoint

  tags = {
    "environment" = var.tag_prod
    "ambiente"    = var.tag_ambiente
  }
}

# Criando Parameter Store para a Porta do banco
resource "aws_ssm_parameter" "db_port" {
  name        = "/api/db_port"
  description = "Porta do banco de dados"
  type        = "String"
  value       = aws_db_instance.rds_api.port

  tags = {
    "environment" = var.tag_prod
    "ambiente"    = var.tag_ambiente
  }
}
