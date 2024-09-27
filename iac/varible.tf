variable "instance_name" {
  type        = string
  description = "Nome da instance ec2 usada para vpn do Pritunl"
  default     = "Pritunl_VPN"
}

variable "tag_prod" {
  type        = string
  description = "tags de produção"
  default     = "production"
}

variable "tag_ambiente" {
  type        = string
  description = "tags IAC"
  default     = "terraform"
}

variable "vpc_name" {
  type        = string
  description = "Defini o nome da vpc"
  default     = "production"
}

variable "ecr_name" {
  type        = string
  description = "Defini o nome do ecr"
  default     = "api-production"
}

variable "ecr_service_name" {
  type        = string
  description = "Defini o nome do serviço ecs"
  default     = "api-production"
}

variable "ecs_cpu" {
  type        = string
  description = "Defini quantidade de cpu do ecs"
  default     = "2048"
}

variable "ecs_memory" {
  type        = string
  description = "Defini quantidade de memory do ecs"
  default     = "4096"
}

variable "domain_name" {
  type        = string
  description = "Certificado para o ACM"
  default     = "brian.pt"
}

variable "rds_instance_type" {
  type        = string
  description = "Tamanho da instancia rds"
  default     = "db.t3.micro"
}




