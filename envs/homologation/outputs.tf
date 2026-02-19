# ===============================================
# RDS OUTPUTS
# ===============================================

output "rds_endpoint" {
  description = "Endpoint do RDS (com porta)"
  value       = module.rds_postgresql.rds_endpoint
}

output "rds_endpoint_without_port" {
  description = "Endpoint do RDS (sem porta)"
  value       = module.rds_postgresql.rds_endpoint_without_port
}

output "rds_port" {
  description = "Porta do RDS"
  value       = module.rds_postgresql.rds_port
}

output "rds_arn" {
  description = "ARN do RDS"
  value       = module.rds_postgresql.rds_arn
}

output "rds_id" {
  description = "ID do RDS"
  value       = module.rds_postgresql.rds_id
}

output "db_name" {
  description = "Nome do banco de dados"
  value       = module.rds_postgresql.db_name
}

output "db_username" {
  description = "Username do banco de dados"
  value       = module.rds_postgresql.db_username
  sensitive   = true
}

output "security_group_id" {
  description = "ID do Security Group do RDS"
  value       = module.rds_postgresql.security_group_id
}

output "jdbc_url" {
  description = "JDBC URL completa"
  value       = module.rds_postgresql.jdbc_url
  sensitive   = true
}
