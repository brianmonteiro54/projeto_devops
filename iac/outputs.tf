output "rds_endpoint" {
  description = "Endpoint da RDS da API"
  value       = aws_db_instance.rds_api.endpoint
}

output "secret_manager_arn" {
  description = "Secret Manger"
  value       = tolist(aws_db_instance.rds_api.master_user_secret)[0].secret_arn
}

output "api_production_uri" {
  description = "url do ecr"
  value       = aws_ecr_repository.api_production.repository_url
}


