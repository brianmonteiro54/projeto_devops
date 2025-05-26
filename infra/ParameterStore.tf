# Criando Parameter Store para o DB Name
resource "aws_ssm_parameter" "db_database" {
  name        = "/${var.tag_environment}/db_database"
  description = "Nome do banco de dados"
  type        = "String"
  value       = aws_db_instance.rds.db_name

  tags = {
    Environment = var.tag_environment
    Ambiente    = var.tag_ambiente
  }
}

# Criando Parameter Store para o Endpoint do banco
resource "aws_ssm_parameter" "db_endpoint" {
  name        = "/${var.tag_environment}/db_endpoint"
  description = "Endpoint do banco de dados"
  type        = "String"
  value       = split(":", aws_db_instance.rds.endpoint)[0] #Pega apenas o endpoint

  tags = {
    Environment = var.tag_environment
    Ambiente    = var.tag_ambiente
  }
}

# Criando Parameter Store para a Porta do banco
resource "aws_ssm_parameter" "db_port" {
  name        = "/${var.tag_environment}/db_port"
  description = "Porta do banco de dados"
  type        = "String"
  value       = aws_db_instance.rds.port

  tags = {
    Environment = var.tag_environment
    Ambiente    = var.tag_ambiente
  }
}
