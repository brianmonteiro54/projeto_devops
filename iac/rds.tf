resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id] # Subnets que fazem parte do VPC

  tags = {
    Name        = "rds-subnet-group"
    Environment = var.tag_prod
  }
}

resource "aws_db_instance" "rds_api" {
  allocated_storage           = 20                    # Alocação inicial de armazenamento em GB
  max_allocated_storage       = 1000                  # Escalabilidade automática até 1000 GB
  engine                      = "postgres"            # Engine do PostgreSQL
  engine_version              = "16.3"                # Versão do PostgreSQL
  instance_class              = var.rds_instance_type # Instância elegível para o Free Tier
  db_name                     = "api"                 # Nome do banco de dados
  identifier                  = "api-production"      # Identificador da instância RDS
  username                    = "postgres"            # Nome de usuário do banco
  manage_master_user_password = true                  # Gerenciamento de credenciais no Secrets Manager
  #master_user_secret_kms_key_id         = var.kms_aws_secretsmanager      # Chave KMS para criptografia do Secrets Manager
  vpc_security_group_ids                = [aws_security_group.api_db.id]          # Grupo de segurança
  db_subnet_group_name                  = aws_db_subnet_group.rds_subnet_group.id # Subnet do VPC
  backup_retention_period               = 7                                       # Período de retenção de backups automáticos
  backup_window                         = "00:00-01:00"                           # Janela de backup diário (UTC)
  performance_insights_enabled          = true                                    # Habilita Performance Insights
  performance_insights_retention_period = 7                                       # Retenção de Performance Insights por 7 dias
  #performance_insights_kms_key_id       = var.kms_aws_rds                 # Chave KMS para Performance Insights
  storage_encrypted = true # Criptografa o armazenamento do RDS
  #kms_key_id                            = var.kms_aws_rds                 # Chave KMS para criptografia do RDS
  multi_az                 = true                #  utiliza multi-AZ 
  publicly_accessible      = false                # Não acessível publicamente
  #availability_zone        = "us-east-1a"         # Zona de disponibilidade
  parameter_group_name     = "default.postgres16" # Grupo de parâmetros do PostgreSQL
  skip_final_snapshot      = true                 # Não fazer snapshot final
  delete_automated_backups = false               # deletar os snapshot automatico
  deletion_protection      = false                # protenção contra deleção

  tags = {
    "environment" = var.tag_prod,
    "ambiente"    = var.tag_ambiente
  }

  timeouts {
    create = "40m"
    delete = "60m"
    update = "80m"
  }
}