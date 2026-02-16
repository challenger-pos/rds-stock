# ===============================================
# OUTPUTS
# ===============================================

output "rds_endpoint" {
  description = "Endpoint do RDS (com porta)"
  value       = aws_db_instance.this.endpoint
}

output "rds_endpoint_without_port" {
  description = "Endpoint do RDS (sem porta)"
  value       = aws_db_instance.this.address
}

output "rds_port" {
  description = "Porta do RDS"
  value       = aws_db_instance.this.port
}

output "rds_arn" {
  description = "ARN do RDS"
  value       = aws_db_instance.this.arn
}

output "rds_id" {
  description = "ID do RDS"
  value       = aws_db_instance.this.id
}

output "db_name" {
  description = "Nome do banco de dados"
  value       = aws_db_instance.this.db_name
}

output "db_username" {
  description = "Username do banco"
  value       = var.db_username
  sensitive   = true
}

output "security_group_id" {
  description = "ID do Security Group"
  value       = aws_security_group.rds.id
}

output "secrets_manager_arn" {
  description = "ARN do secret"
  value       = aws_secretsmanager_secret.rds_credentials.arn
}

output "secrets_manager_name" {
  description = "Nome do secret"
  value       = aws_secretsmanager_secret.rds_credentials.name
}

output "jdbc_url" {
  description = "JDBC URL"
  value       = "jdbc:postgresql://${aws_db_instance.this.endpoint}/${var.db_name}"
  sensitive   = true
}
