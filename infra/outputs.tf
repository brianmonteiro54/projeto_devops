output "rds_endpoint" {
  description = "Endpoint do RDS"
  value       = aws_db_instance.rds.endpoint
}

output "secret_manager_arn" {
  description = "Secret Manger"
  value       = tolist(aws_db_instance.rds.master_user_secret)[0].secret_arn
}

output "ecr_uri" {
  description = "url do ecr"
  value       = aws_ecr_repository.app_ecr.repository_url
}


