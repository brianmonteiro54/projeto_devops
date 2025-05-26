variable "instance_name" {
  type        = string
  description = "Nome da instance ec2 usada para vpn do Pritunl"
}

variable "tag_environment" {
  type        = string
  description = "tags do ambiente"
}

variable "tag_ambiente" {
  type        = string
  description = "tags IAC"
}

variable "vpc_name" {
  type        = string
  description = "Defini o nome da vpc"
}


variable "vpc_cidr_block" {
  type        = string
  description = "CIDR da VPC"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "CIDRs das subnets públicas (2)"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "CIDRs das subnets privadas (2)"
}

variable "availability_zones" {
  type        = list(string)
  description = "Zonas de disponibilidade para as subnets"
}

variable "ecr_name" {
  type        = string
  description = "Defini o nome do ecr"
}

variable "ecr_service_name" {
  type        = string
  description = "Defini o nome do serviço ecs"
}

variable "ecs_cpu" {
  type        = string
  description = "Defini quantidade de cpu do ecs"
}

variable "ecs_memory" {
  type        = string
  description = "Defini quantidade de memory do ecs"
}

variable "domain_name" {
  type        = string
  description = "Certificado para o ACM"
}

variable "rds_instance_type" {
  type        = string
  description = "Tamanho da instancia rds"
}

variable "rds_identifier" {
  type        = string
  description = "Identificador único da instância RDS"
}

variable "rds_multi-az" {
  type        = bool
  description = "Define se a instância RDS deve ser implantada com alta disponibilidade (Multi-AZ). Use 'true' ou 'false'"
}

variable "rds_delete_automated_backups" {
  type        = bool
  description = "Define se os backups automatizados da instância RDS devem ser excluídos automaticamente ao excluir a instância. Use 'true' ou 'false'."
}


variable "rds_db_name" {
  type        = string
  description = "Nome do banco de dados"
}

variable "rds_parameter_group" {
  type        = string
  description = "Grupo de parâmetros do RDS"
}

variable "rds_engine" {
  type        = string
  description = "Engine do RDS"
}

variable "rds_engine_version" {
  type        = string
  description = "Version do engine do RDS"
}

variable "rds_username" {
  type        = string
  description = "Nome do usuário do RDS"
}

variable "rds_backup_retention_period" {
  type        = number
  description = "Define o período de retenção dos backups automáticos do banco de dados RDS, em dias."
}

variable "cloudtrail_name" {
  type        = string
  description = "Nome do CloudTrail para o ambiente"
}

variable "cloudtrail_s3_bucket_prefix" {
  type        = string
  description = "Prefixo do bucket S3 para o CloudTrail"
}

variable "cloudtrail_s3_key_prefix" {
  type        = string
  description = "Prefixo da chave dentro do bucket S3 para armazenar logs do CloudTrail"
}

variable "iam_role_name" {
  type        = string
  description = "Nome da IAM Role para EC2"
}

variable "instance_profile_name" {
  type        = string
  description = "Nome do Instance Profile associado à Role"
}

variable "ami_id" {
  type        = string
  description = "AMI ID da instância EC2 para VPN"
}

variable "instance_type" {
  type        = string
  description = "Tipo da instância EC2"
}

variable "ecs_cluster_name" {
  type        = string
  description = "Nome do cluster ECS para o ambiente"
}

variable "ecs_service_name" {
  type        = string
  description = "Nome do serviço ECS"
}

variable "ecs_desired_count" {
  type        = number
  description = "Quantidade desejada de instâncias(taks) do serviço ECS"
}

variable "container_name" {
  type        = string
  description = "Nome do container para o serviço ECS"
}

variable "container_port" {
  type        = number
  description = "Porta do container para o serviço ECS"
}

variable "alb_name" {
  type        = string
  description = "Nome do Application Load Balancer"
}

variable "alb_target_group_name" {
  type        = string
  description = "Nome do target group do ALB"
}

variable "waf_acl_name" {
  type        = string
  description = "Nome do Web ACL (WAF)"
}

variable "waf_description" {
  type        = string
  description = "Descrição do Web ACL"
  default     = "Web ACL gerenciado via Terraform"
}

variable "waf_metric_name" {
  type        = string
  description = "Nome da métrica do Web ACL para o CloudWatch"
}

variable "ecs_min_capacity" {
  description = "Capacidade mínima do serviço ECS"
  type        = number
}

variable "ecs_max_capacity" {
  description = "Capacidade máxima do serviço ECS"
  type        = number
}

variable "scale_up_cpu_threshold" {
  description = "Limite percentual de CPU para escalonamento para cima"
  type        = number
}

variable "scale_down_cpu_threshold" {
  description = "Limite percentual de CPU para escalonamento para baixo"
  type        = number
}

variable "scale_up_cooldown" {
  description = "Cooldown (segundos) após escalonamento para cima"
  type        = number
}

variable "scale_down_cooldown" {
  description = "Cooldown (segundos) após escalonamento para baixo"
  type        = number
}