# ===============================================
# AWS SECRETS MANAGER - NÃO UTILIZADO
# ===============================================

# Este módulo não cria secrets no AWS Secrets Manager para reduzir custos e complexidade.
# As credenciais do RDS são gerenciadas via variáveis sensíveis do Terraform.
# 
# Se necessário no futuro, descomente o código abaixo:
#
# resource "aws_secretsmanager_secret" "rds_credentials" {
#   name        = "${var.project}/${var.service}/rds/${var.environment}"
#   description = "RDS credentials for ${var.service} service in ${var.environment}"
# 
#   tags = merge(
#     var.tags,
#     {
#       Name = "${var.project}-${var.service}-rds-secret-${var.environment}"
#     }
#   )
# }
# 
# resource "aws_secretsmanager_secret_version" "rds_credentials" {
#   secret_id = aws_secretsmanager_secret.rds_credentials.id
#   secret_string = jsonencode({
#     username            = var.db_username
#     password            = var.db_password
#     engine              = "postgres"
#     host                = aws_db_instance.this.address
#     port                = aws_db_instance.this.port
#     dbname              = var.db_name
#     dbInstanceIdentifier = aws_db_instance.this.identifier
#     jdbcUrl             = "jdbc:postgresql://${aws_db_instance.this.endpoint}/${var.db_name}"
#   })
# }
